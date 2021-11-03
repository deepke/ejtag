import re, sys, os, gdb, math, struct, time
try:
 gdb.execute('set python print-stack full')
except Exception:
 pass

if sys.version_info[0]<3: int = long 
#pci_type0_conf_addr=0xffffffffba000000
#pci_type1_conf_addr=0xffffffffbb000000
pci_type0_conf_addr=0x900000fe00000000
pci_type1_conf_addr=0x900000fe00000000
def ulong(x):
   return int(x) & longmask

def container_of(p,stype,member):
   t=gdb.lookup_type(stype).pointer()
   z=gdb.Value(0).cast(t) 
   for i in member.split('.'):
     z=z[i]
   return gdb.Value(int(p)-int(z.address)).cast(t)

pgdorder = 0

class MycmdCommand(gdb.Command):
    def accessvm(self,addr):
            addr = int(addr)
            if (addr&0xf000000000000000) == 0xc000000000000000:
                pgd = ulong(self['swapaddr'])
            elif (addr&0xffffffffc0000000) == 0xffffffffc0000000:
                pgd = ulong(self['swapaddr'])
            else :
                pgd = ulong(self['pgd'])
            pagesize = self['pagesize']
            pageshift = self['pageshift']
            pteshift = self['pteshift']
            enable64 = self['enable64']
            pgdmask = (((1+pgdorder)<<pageshift)-longsize);
            mask = ((1<<pageshift)-longsize);
            mask1 = ((1<<pageshift)-longsize*2);
    #right shift(14+1), left shit log2(2item) : 11 = (14+1-4) (pageshift+1-log2(2item)) 
    # 11 = (14-3)
    # 12-2
    
            if self['pagelevel'] == 3:
              pud=self._read_word(((addr>>((pageshift-longshift)*3))&pgdmask) + pgd);
            else :
              pud = pgd
            pmd=self._read_word(((addr>>((pageshift-longshift)*2))&mask) + pud);
            pte=self._read_word(((addr>>(pageshift-longshift)) & mask1) + pmd);
            pte1=self._read_word(((addr>>(pageshift-longshift)) & mask1) + longsize + pmd);
            self['d_pgd'] = pgd
            self['d_pud'] = pud
            self['d_pmd'] = pmd
            self['d_pmd_addr'] = ((addr>>((pageshift-longshift)*2))&mask) + pud
            self['d_pte'] = pte
            self['d_pte_addr'] = ((addr>>(pageshift-longshift)) & mask1) + pmd
            self['d_pte1'] = pte1
            self['d_pte1_addr'] = ((addr>>(pageshift-longshift)) & mask1) + longsize + pmd
    
            if addr&(1<<pageshift):
                if pte1&(2<<pteshift):
                    phyaddr = ((pte1>>(pteshift+6))<<12) + (addr&((1<<pageshift)-1))
                    if phyaddr >= 0x20000000:
                        if not enable64:
                            print("physical address is too large 0x%x" %(phyaddr))
                            return {'addr':0,'valid':False}
                        addr1 = (0x9800000000000000,0x9000000000000000)[((pte1>>(pteshift+3))&7)!=3] + phyaddr;
                    else :
                        addr1 = (ulong(0xffffffff80000000),ulong(0xffffffffa0000000))[((pte1>>(pteshift+3))&7)!=3] + phyaddr;
                else :
                	return {'addr':0, 'valid':False};
            else :
                if pte&(2<<pteshift) :
                    phyaddr = ((pte>>(pteshift+6))<<12)  + (addr&((1<<pageshift)-1))
                    if phyaddr >= 0x20000000:
                         if not enable64:
                            print("physical address is too large 0x%x" %(phyaddr))
                            return {'addr':0, 'valid':False}
                         addr1 = (0x9800000000000000,0x9000000000000000)[((pte>>(pteshift+3))&7)!=3] + phyaddr;
                    else :
                         addr1 = (ulong(0xffffffff80000000),ulong(0xffffffffa0000000))[((pte>>(pteshift+3))&7)!=3] + phyaddr;
                else :
                 	return {'addr':0, 'valid':False};
    
    
            return {'addr':addr1, 'valid':True, 'phyaddr':phyaddr, 'pte0':pte, 'pte1':pte1,'len':pagesize-(addr&(pagesize-1))};
    def fullpath(self, d):
     pname=[]
     while 1: 
      pname.insert(0,d['d_name']['name'].string())
      if int(d['d_parent']) == int(d): break
      d=d['d_parent']
     return("/".join(pname))
    def page2pfn(page):
      pgt = gdb.lookup_type('struct page').pointer()
      mem_map = gdb.parse_and_eval('mem_map')
      if mem_map:
         pfn=gdb.Value(p).cast(pgt)-mem_map
      else :
       mem_section = gdb.parse_and_eval('mem_section')
       n= mem_section.type.sizeof//mem_section[0].type.sizeof
       o = int(gdb.Value(p).cast(pgt)['flags'])//(0x100000000//n)
       pfn=gdb.Value(p).cast(pgt)-gdb.Value(mem_section[o][0]['section_mem_map']&~3).cast(pgt)
      return pfn

    def downloadfile1(self,d,rw=0, maxsize=0x100000000):
      name = d['d_name']['name'].string()
      print(name)
      size=int(d['d_inode']['i_size'])
      m=d['d_inode']['i_mapping']
      pagesize = self['pagesize']
      pos = 0
      nodes=[]
      size = min(size,maxsize)
      while pos < size:
         index = pos // pagesize
         page = gdb.parse_and_eval('find_get_entry(' +hex(m) +"," + hex(index)+")")
         nodes.append(page)
         pos += pagesize
      pgt = gdb.lookup_type('struct page').pointer()
      mem_map = gdb.lookup_global_symbol('mem_map')
      if not mem_map or not int(mem_map.value()):
         usememmap = 0
      else :
         usememmap =1
         mem_map = mem_map.value()
      page_offset = 0x9800000000000000 if gdb.lookup_type('long').sizeof == 8 else 0x80000000
      if not usememmap:
       mem_section = gdb.parse_and_eval('mem_section')
       n= mem_section.type.sizeof//mem_section[0].type.sizeof
       sections_pgdiv = (1<<gdb.lookup_type('long').sizeof*8)//n

      pagesize = self['pagesize']
      addrs=[]
      inf = gdb.selected_inferior()

      for page in nodes:
        if usememmap:
         pfn=page-mem_map
        else :
         o = int(page['flags'])//sections_pgdiv
         pfn=page-gdb.Value(mem_section[o][0]['section_mem_map']&~7).cast(pgt)
        a=page_offset+pfn*pagesize
        addrs.append(a)

      if rw < 2:
        f=open('/tmp/' + name,'wb' if not rw else 'rb')
      pos = 0
      for a in addrs:
        if not rw:
          m = inf.read_memory(a, pagesize if size>pagesize else size)
          f.write(m.tobytes())
        elif rw == 1:
          buf=f.read(pagesize if size>pagesize else size)
          if not buf: break
          inf.write_memory(a, buf)
        elif rw == 2:
          print("%08lx:\t %16lx" % (pos, a))
        else :
          print("%08lx:\t %s" % (pos, inf.read_memory(a,16).tobytes()))
        size -= pagesize
        pos  += pagesize
         
      if rw < 2:
        f.close()
    def downloadfile(self,d, rw=0, maxsize=0x100000000):
      name = d['d_name']['name'].string()
      print(name)
      size=int(d['d_inode']['i_size'])
      t=d['d_inode']['i_mapping']['page_tree']
      rnode = int(str(t['rnode']),0)
      pagesize = self['pagesize']
      maxsize //= pagesize;
      
      indirect = (rnode&1)
      if gdb.lookup_global_symbol('init_fs').type['root'].type==gdb.lookup_type('struct dentry').pointer():
        indirect=not indirect
      if indirect:
       stack=[]
       h = int(t['height'])
       nd = rnode&~1
       stack.append([nd,h])
       nodes=[]
       
       while len(stack) and maxsize:
         n,h=stack.pop(0)
         i=0
         node = gdb.Value(n).cast(t['rnode'].type)
         while maxsize:
           n1= node['slots'][i]
           if n1:
            if h>1:
             stack.insert(i,[n1,h-1])
            else:
             nodes.append(n1)
             maxsize -= 1
           else :
            break
           i+=1
      else :
       nodes=[rnode]
       maxsize -= 1
      

      pgt = gdb.lookup_type('struct page').pointer()
      mem_map = gdb.lookup_global_symbol('mem_map')
      if not mem_map or not int(mem_map.value()):
         usememmap = 0
      else :
         usememmap =1
         mem_map = mem_map.value()
      page_offset = 0x9800000000000000 if gdb.lookup_type('long').sizeof == 8 else 0x80000000
      if not usememmap:
       mem_section = gdb.parse_and_eval('mem_section')
       n= mem_section.type.sizeof//mem_section[0].type.sizeof
       sections_pgdiv = (1<<gdb.lookup_type('long').sizeof*8)//n

      addrs=[]
      inf = gdb.selected_inferior()

      for p in nodes:
        if usememmap:
         pfn=gdb.Value(p).cast(pgt)-mem_map
        else :
         o = int(gdb.Value(p).cast(pgt)['flags'])//sections_pgdiv
         pfn=gdb.Value(p).cast(pgt)-gdb.Value(mem_section[o][0]['section_mem_map']&~7).cast(pgt)
        a=page_offset+pfn*pagesize
        addrs.append(a)

      if rw < 2:
        f=open('/tmp/' + name,'wb' if not rw else 'rb')
      pos = 0
      for a in addrs:
        if not rw:
          m = inf.read_memory(a, pagesize if size>pagesize else size)
          f.write(m.tobytes())
        elif rw == 1:
          buf=f.read(pagesize if size>pagesize else size)
          if not buf: break
          inf.write_memory(a, buf)
        elif rw == 2:
          print("%08lx:\t %16lx" % (pos, a))
        else :
          print("%08lx:\t %s" % (pos, inf.read_memory(a,16).tobytes()))
        size -= pagesize
        pos  += pagesize
         
      if rw < 2:
        f.close()
    def __init__(self):
        gdb.Command.__init__(self, 'mycmd', gdb.COMMAND_DATA,
                             gdb.COMPLETE_COMMAND, True)
        global longmask, longsize, longshift
        longsize = gdb.lookup_type('unsigned long').sizeof
        longmask = ((1<<longsize*8)-1)
        longshift = int(math.log(longsize, 2))
        self.data={}
        self.data['char_ptr_t'] = gdb.lookup_type("unsigned char").pointer()
        self.data['char_ptr_ptr_t'] = self.data['char_ptr_t'].pointer()
        self.data['pagelevel'] = 2 if longsize==4 else 3
        self.data['enable64'] = 1 if longsize==8 else 0
  
    def _read_word(self, address):
        return ulong(gdb.Value(address).cast(self['char_ptr_ptr_t']).dereference())
    def ls(self, arg, from_tty):
       dirs=list(filter(len,arg.split('/')))
       fs=gdb.parse_and_eval('init_fs')
       if fs['root'].type==gdb.lookup_type('struct dentry').pointer():
         rd = fs['root']
       else :
         rd = fs['root']['dentry'] 
       t = rd['d_subdirs']['next']
       while int(t)!=int(rd['d_subdirs'].address):
        if rd.type.has_key('d_child'):
          a = int(t) - int(gdb.Value(0).cast(rd.type)['d_child'].address)
        else :
          a = int(t) - int(gdb.Value(0).cast(rd.type)['d_u']['d_child'].address)
        d=gdb.Value(a).cast(rd.type)
        name = d['d_name']['name'].string()
        if not dirs:
           size=int(d['d_inode']['i_size']) if d['d_inode'] else 0
           print(name, size)
        elif name == dirs[0]:
          
           if ((d['d_inode']['i_mode']>>12)&0xf) != 4:
            size=int(d['d_inode']['i_size'])
            print(d['d_name']['name'], size)
           else :
             dirs.pop(0)
             rd = d
             t = rd['d_subdirs']['next']
             continue
        t=t['next']
    def get(self, arg, rw=0, maxsize=0x100000000):
       dirs=list(filter(len,arg.split('/')))
       fs=gdb.parse_and_eval('init_fs')
       if fs['root'].type==gdb.lookup_type('struct dentry').pointer():
         rd = fs['root']
       else :
         rd = fs['root']['dentry'] 
       t = rd['d_subdirs']['next']
       while int(t)!=int(rd['d_subdirs'].address):
        if rd.type.has_key('d_child'):
          a = int(t) - int(gdb.Value(0).cast(rd.type)['d_child'].address)
        else :
          a = int(t) - int(gdb.Value(0).cast(rd.type)['d_u']['d_child'].address)
        d=gdb.Value(a).cast(rd.type)
        name = d['d_name']['name'].string()
        if not dirs:
           print('missing file name')
           return
        elif name == dirs[0]:
          
           if ((d['d_inode']['i_mode']>>12)&0xf) != 4:
            if gdb.lookup_global_symbol('find_get_entry'):
              self.downloadfile1(d, rw, maxsize)
            else :
              self.downloadfile(d, rw, maxsize)
            return
           else :
             dirs.pop(0)
             rd = d
             t = rd['d_subdirs']['next']
             continue
        t=t['next']
    def linuxver(self):
        if 'ver' not in self.data:
           linux_banner=gdb.lookup_global_symbol('linux_banner').value()
           l=list(map(int,re.findall(r'Linux version (\d)\.(\d+)\.(\d+)',str(linux_banner))[0]))
           self.data['linuxver'] = (l[0]<<16)|(l[1]<<8)|l[2]
        return self.data['linuxver']
    def getpagesize(self):
        if 'pagesize' not in self.data:
          pagesize = 0x4000
          if self.linuxver()>=0x20600:
              init_task = gdb.lookup_global_symbol('init_task').value().address
              next_task=gdb.Value(int(init_task['tasks']['next'])-int(gdb.Value(0).cast(init_task.type)['tasks'].address)).cast(init_task.type)
              mm=next_task['mm']
              if mm:
                elf_info=mm['saved_auxv'].address.cast(gdb.lookup_type('int').pointer())
                if elf_info[2] == 0:
                  elf_info=mm['saved_auxv'].address.cast(gdb.lookup_type('long long').pointer())
                i=0
                while i<32:
                   t= int(elf_info[i])
                   if t==6:
                     pagesize = int(elf_info[i+1])
                     break
                   i+=2
          self.data['pagesize'] = pagesize
          try:
           gdb.execute("monitor setpgsize " + str(mycmd['pagesize']))
          except gdb.error:
           pass
        return self.data['pagesize']

    def getcurrent(self,cpuno=0):
     kernelsp = gdb.lookup_global_symbol('kernelsp').value()
     if self['linuxver']>=0x20600:
       current = gdb.Value(kernelsp[cpuno]&~(gdb.lookup_type('union thread_union').sizeof-1)).cast(gdb.lookup_type('struct thread_info').pointer())
       if current:
         task = current['task']
       else :
         task = None
     else :
       current = gdb.Value(kernelsp[cpuno]&~(gdb.lookup_type('union thread_union').sizeof-1)).cast(gdb.lookup_type('struct task_struct').pointer())
       task = current
     return (current,task)
    def get_curtasks(self):
      init_task = gdb.lookup_global_symbol('init_task').value().address
      kernelsp = gdb.lookup_global_symbol('kernelsp').value()

      curtasks = []
      atasks = {}
      for i in  range(kernelsp.type.sizeof//kernelsp[0].type.sizeof):
             current  = self.getcurrent(i)[1]
             if not current: break
             curtasks.append(current)
      self['curtasks'] = curtasks

    def task(self):
         init_task = gdb.lookup_global_symbol('init_task').value().address
         for task in self['curtasks']:
             if not init_task.type.has_key('stack'):
               tinfo = task['thread_info']
               uregs = gdb.Value(int(task['thread_info'])+gdb.lookup_type('union thread_union').sizeof-32-gdb.lookup_type('struct pt_regs').sizeof).cast(gdb.lookup_type('struct pt_regs').pointer())
             else :
               tinfo = task['stack'].cast(gdb.lookup_type('struct thread_info').pointer())
               #__KSTK_TOS
               uregs = gdb.Value(int(task['stack'])+gdb.lookup_type('union thread_union').sizeof-32-gdb.lookup_type('struct pt_regs').sizeof).cast(gdb.lookup_type('struct pt_regs').pointer())
    
    
             sys.stdout.write("%d %d %s ra=%#x sp=%#x epc=%#x usp=%#x task=%#x tinfo=%#x uregs=%#x stat=%#x\n" %(task['pid'], task['parent']['pid'], task['comm'].string(),ulong(task['thread']['reg31']),ulong(task['thread']['reg29']),ulong(uregs['cp0_epc']),ulong((uregs['regs'][29])),ulong(task), ulong(tinfo), ulong(uregs), ulong(task['state'])))
          

    def tasks(self,show=1):
      init_task = gdb.lookup_global_symbol('init_task').value().address
      kernelsp = gdb.lookup_global_symbol('kernelsp').value()

      curtasks = []
      atasks = {}
      for i in  range(kernelsp.type.sizeof//kernelsp[0].type.sizeof):
             current  = self.getcurrent(i)[1]
             if not current: break
             curtasks.append(current)

      p = init_task['tasks'].address

      while p:
       task= gdb.Value(int(p)-int(gdb.Value(0).cast(init_task.type)['tasks'].address)).cast(init_task.type)
       curtask=task
       while task:
         if not init_task.type.has_key('stack'):
           tinfo = task['thread_info']
           uregs = gdb.Value(int(task['thread_info'])+gdb.lookup_type('union thread_union').sizeof-32-gdb.lookup_type('struct pt_regs').sizeof).cast(gdb.lookup_type('struct pt_regs').pointer())
         else :
           tinfo = task['stack'].cast(gdb.lookup_type('struct thread_info').pointer())
           uregs = gdb.Value(int(task['stack'])+gdb.lookup_type('union thread_union').sizeof-32-gdb.lookup_type('struct pt_regs').sizeof).cast(gdb.lookup_type('struct pt_regs').pointer())
         atasks[int(task['pid'])]=[task,tinfo,uregs]


         if show:
           if task in curtasks:
                 sys.stdout.write("*<%d> "%curtasks.index(task))
           if  task.type.has_key('on_rq'):
                 sys.stdout.write("%s " % ( "R" if task['on_rq'] else " "))
           #print_task(task)
           sys.stdout.write("%d %d %s ra=%#x sp=%#x epc=%#x usp=%#x task=%#x tinfo=%#x uregs=%#x stat=%#x\n" %(task['pid'], task['parent']['pid'], task['comm'].string(),ulong(task['thread']['reg31']),ulong(task['thread']['reg29']),ulong(uregs['cp0_epc']),ulong((uregs['regs'][29])),ulong(task), ulong(tinfo), ulong(uregs), ulong(task['state'])))
      
         t = task['thread_group']['next']
         if t==curtask['thread_group'].address or not t:
            break
         task = gdb.Value(int(t) - int(gdb.Value(0).cast(task.type)['thread_group'].address)).cast(task.type)
       p=p['next']
       if p==init_task['tasks'].address:
         break
      self['tasks']=atasks
      self['curtasks'] = curtasks
      print("==\t\tcurrent tasks\t\t==");
      for task in curtasks:
        print("%d %s" % (task['pid'], task['comm'].string()))
    def probepte(self):
        pteshift = 6
        for i in range(0x30,0x80,4):
            ins = self._read_word(ulong(0xffffffff80000000+(longsize==8)*0x80)+i);
            #srl
            if ((ins & 0xffe0003f) == 2):
                pteshift = ((ins>>6)&0x1f);
            #dsrl
            if ((ins & 0xffe0003f) == 0x3a):
                pteshift = ((ins>>6)&0x1f);
            #mtc0
            if ((ins & 0xffe00000) == 0x40800000):
                break;
        self.data['pteshift'] = pteshift
    def __getitem__(self,key):
        if type(key) != str: raise Exception('error no key')
        if key[-1] != ')' and key in self.data: return self.data[key]
        elif key == 'linuxver': return self.linuxver()
        elif key == 'tasks':
           self.tasks(False)
        elif key == 'curtasks':
           self.get_curtasks()
        elif key == 'curtask':
           task = self.data['curtask'] = self.getcurrent()[1]
           pgd = task['mm']['pgd'] if task['mm'] else self['swapaddr']
           self.data['pgd'] = pgd
        elif key == 'pgd':
           task=self['curtask']   
        elif key == 'pagesize': self.getpagesize()
        elif key == 'pageshift':
           self.data['pageshift'] = int(math.log(self['pagesize'],2))
        elif key == 'pteshift': self.probepte()
        elif key == 'swapaddr': self.data['swapaddr'] = gdb.lookup_global_symbol('swapper_pg_dir').value().address 
        elif key == 'tinfo()':
             self.data[key] = gdb.Value(gdb.newest_frame().read_register("gp")).cast(gdb.lookup_type('struct thread_info').pointer())
        elif key == 'irq_regs()':
             self.data[key] = gdb.Value(gdb.newest_frame().read_register("gp")).cast(gdb.lookup_type('struct thread_info').pointer())['regs']
        elif key.startswith('_'):
           self.data[key] = None
        else : raise Exception('error no key')
        return self.data[key]

    def __setitem__(self,key,val):
        self.data[key] = val
        if key == 'curtask':
           task = val
           pgd = task['mm']['pgd'] if task['mm'] else self['swapaddr']
           self.data['pgd'] = pgd

    def pidsel(self,pid):
        self['curtask'] = self['tasks'][pid][0]
        pgd = self['pgd']
        gdb.execute("monitor setpgd %#x\n" % ulong(pgd))

    def tasksel(self,task):
        self['curtask'] = gdb.Value(task).cast(gdb.lookup_type('struct task_struct').pointer())
        pgd = self['pgd']
        gdb.execute("monitor setpgd %#x\n" % ulong(pgd))

    def modules24(self):
      mod = gdb.lookup_symbol('module_list')[0].value()
      while mod and mod['next']:
       s=os.popen("./tools/load-module24" + (".mips64" if (longsize==8) else "") + "\tmodules/%s.o %#x" %(mod['name'].string(), ulong(mod))).read()
       print(s)
       gdb.execute(s)
       mod=mod['next']

    def modules0(self, modpath='modules'):
      modules = gdb.lookup_symbol('modules')[0].value().address
      #modules = gdb.Value(0xffffffff80b533c8).cast(gdb.lookup_symbol('modules')[0].type.pointer())
      modlst = modules['next']
      modtype=gdb.lookup_type('struct module').pointer()
      mcnt=0
      modsecs={}
      while modlst != modules:
        mod= gdb.Value(int(modlst)-int(gdb.Value(0).cast(modtype)['list'].address)).cast(modtype)
        s=''
        attrs=mod['sect_attrs']
        nsections = mod['sect_attrs']['nsections']
        n=0
        while n<nsections:
         attrsn = mod['sect_attrs']['attrs'][n]
         s+= "-s %s %#x " % ( attrsn['name'].string(),ulong(attrsn['address']))
         modsecs[attrsn['name'].string()]=ulong(attrsn['address'])
         n=n+1
        s0= "add-symbol-file\t" + modpath +"/%s.ko %#x " % (mod['name'].string(),modsecs['.text'])
        gdb.execute(s0+s)
        modlst = modlst['next']
    
    def modules(self,modpath='modules'):
      kallsyms = gdb.lookup_global_symbol('module_kallsyms_lookup_name')!=None
      modules = gdb.lookup_symbol('modules')[0].value().address
      modlst = modules['next']
      modtype=gdb.lookup_type('struct module').pointer()
      while modlst != modules:
        mod= gdb.Value(int(modlst)-int(gdb.Value(0).cast(modtype)['list'].address)).cast(modtype)
        s=os.popen("./tools/load-module\tmodules/%s.ko %#x %#lx %d" %(mod['name'].string(), ulong(mod['module_core']), ulong(mod['module_init']), self['linuxver']<0x2061f and kallsyms)).read()
        gdb.execute(s)
        modlst = modlst['next']
    def vma(self,pid=-1):
      if pid == -1: task = self['curtask']
      else : task = self['tasks'][pid][1]
      if task['mm']:
        t=task['mm']['mmap']
        while t:
          gdb.write("%#x-%#x %c%c%c%c %x " % ( ulong(t['vm_start']),ulong(t['vm_end']), t['vm_flags']&1 and 'r' or '-',t['vm_flags']&2 and 'w' or '-',t['vm_flags']&4 and 'x' or '-',t['vm_flags']&8 and 's' or '-',ulong(t['vm_pgoff'])*16*1024))
          if t['vm_file']:
            inode = t['vm_file']['f_path']['dentry']['d_inode']
            gdb.write("%02x:%02x %lu %s"%( ulong(inode['i_sb']['s_dev'])>>20, ulong(inode['i_sb']['s_dev'])&0xfffff, inode['i_ino'],self.fullpath(t['vm_file']['f_path']['dentry'])))
          gdb.write('\n')
          t = t['vm_next']
      gdb.write('\n')
    def fds(self):
      task = self['curtask']
      files = task['files']
      fdt = files['fdt']
      for i in range(int(fdt['max_fds'])):
        file = fdt['fd'][i]
        if file:
          gdb.write('%d\t->\t%s\n'%(i,self.fullpath(file['f_path']['dentry']))) 

    def interrupts(self):
      kernelsp = gdb.lookup_global_symbol('kernelsp').value()
      irq_desc = gdb.lookup_global_symbol('irq_desc').value()
      __per_cpu_offset = gdb.lookup_global_symbol('__per_cpu_offset')
      per_cpu__kstat = gdb.lookup_global_symbol('per_cpu__kstat')
      cpus = kernelsp.type.sizeof//kernelsp[0].type.sizeof
      nr_cpu_ids = gdb.lookup_global_symbol('nr_cpu_ids')
      if nr_cpu_ids: cpus = int(nr_cpu_ids.value())
      nirqs = irq_desc.type.sizeof//irq_desc[0].type.sizeof
      for i in range(nirqs):
        if not irq_desc[i]['action']: continue
        if irq_desc[i].type.has_key('kstat_irqs') and not irq_desc[i]['kstat_irqs']: continue
        gdb.write('%d: ' % i)
        for j in range(cpus):
          if self['linuxver'] >= 0x20637 and __per_cpu_offset:
            per_cpu_offset = __per_cpu_offset.value()[j]
            kstat_irqs = gdb.Value(int(irq_desc[i]['kstat_irqs'])+per_cpu_offset).cast(irq_desc[i]['kstat_irqs'].type).dereference()
            gdb.write('%d ' % kstat_irqs)
          elif __per_cpu_offset and per_cpu__kstat and per_cpu__kstat.type.has_key('irqs'):
            per_cpu_offset = __per_cpu_offset.value()[j]
            per_cpu__kstat_v = per_cpu__kstat.value()
            kstat_irqs = gdb.Value(int(per_cpu__kstat_v.address)+per_cpu_offset).cast(per_cpu__kstat_v.type.pointer()).dereference()
            gdb.write('%d ' % kstat_irqs['irqs'][i])
          elif per_cpu__kstat:
            gdb.write('%d ' % per_cpu__kstat.value()['irqs'][i])
          else :
            gdb.write('%d ' % irq_desc[i]['kstat_irqs'][j])
        if self['linuxver'] >= 0x30000:
          gdb.write('%s ' %(irq_desc[i]['irq_data']['chip']['name'].string()))
        else :
          gdb.write('%s ' %(irq_desc[i]['chip']['name'].string()))

        action = irq_desc[i]['action']
        while action:
         gdb.write('%s ' %action['name'].string())
         action = action['next']
        gdb.write('\n');

    def regs_save(self):
     if self['_regs']: return

     fm = gdb.newest_frame()
     regs={}
     for i in range(32):
       regs[i] = fm.read_register(str(i))
     regs['pc'] = fm.read_register('pc')
     self['_regs'] = regs

    def regs_restore(self):
     if not self['_regs']: return
     for i in range(32):
       gdb.execute('set $r%d=%#x'%(i,ulong(self['_regs'][i]))) 
     gdb.execute('set $pc=%#x'%(ulong(self['_regs']['pc']))) 
     self['_regs'] = None

    def switch_panic(self):
     self.regs_save()
     regs={}
     names={0:'zero',1:'at',2:'v0',3:'v1',4:'a0',5:'a1',6:'a2',7:'a3',8:'a4',9:'a5',10:'a6',11:'a7',12:'t0',
     13:'t1',14:'t2',15:'t3',16:'s0',17:'s1',18:'s2',19:'s3',20:'s4',21:'s5',22:'s6',23:'s7',24:'t8',25:'t9',26:'k0',27:'k11',
     28:'gp',29:'sp',30:'s8',31:'ra',37:'pc'}
     
     l=sys.stdin.readline()
     while l:
       m=re.search('(\d+)\s+:',l)
       if m:
          idx=int(m.groups()[0], 0)
          m=re.findall('[0-9a-f]{8,}',l)
          for i in m:
           regs[idx] = i
           idx +=1
       m=re.search('epc\s+:\s+([0-9a-f]{8,})',l)
       if m:
          regs[37] = m.groups()[0]
     
       l = sys.stdin.readline()
     
     for i in names:
        if i in regs:
           print('set $' +names[i]+'=0x'+regs[i])
           #gdb.execute('set $' +names[i]+'=0x'+regs[i])


    def switch_exception(self, pregs):
     self.regs_save()
     kr={1:'at',2:'v0',3:'v1',4:'a0',5:'a1',6:'a2',7:'a3',8:'a4',9:'a5',10:'a6',11:'a7',12:'t0',13:'t1',14:'t2',15:'t3',16:'s0',17:'s1',18:'s2',19:'s3',20:'s4',21:'s5',22:'s6',23:'s7',24:'t8',25:'t9',26:'k0',27:'k11',28:'gp',29:'sp',30:'s8',31:'ra',37:'pc'}

     pt_regs = gdb.parse_and_eval('((struct pt_regs *)%#x)'%pregs)

     for i in range(1,32):
       gdb.execute('set $%s=%#x'%(kr[i],ulong(pt_regs['regs'][i]))) 
     gdb.execute('set $pc=%#x'%(ulong(pt_regs['cp0_epc']))) 

    def switch_kernel(self):
     self.regs_save()
     kr = {31:'pc',29:'sp',30:'s8',23:'s7',22:'s6',21:'s5',20:'s4',19:'s3',18:'s2',17:'s1',16:'s0'}

     for i in kr:
       gdb.execute('set $%s=%#x'%(kr[i],ulong(self['curtask']['thread']['reg'+str(i)]))) 

    def switch_user(self):
     self.regs_save()
     pid=int(self['curtask']['pid'])
     uregs = self['tasks'][pid][2]

     for i in range(32):
       gdb.execute('set $r%d=%#x'%(i,ulong(uregs['regs'][i]))) 
     gdb.execute('set $pc=%#x'%(ulong(uregs['cp0_epc']))) 

    def cmdline(self):
      mm = self['curtask']['mm']
      if not mm: return
      arg_start = mm['arg_start']
      arg_end = mm['arg_end']
      arg_len = arg_end - arg_start

      env_start = mm['env_start']
      env_end = mm['env_end']
      env_len = env_end - env_start
      va=self.accessvm(arg_start)
      if not va['valid']: return

      ve=self.accessvm(env_start)
      if not ve['valid']: return

      inf = gdb.selected_inferior()
      m = inf.read_memory(va['addr'], arg_len)
      buf = m.tobytes()
      gdb.write('args:\n'+str(buf)+'\n')
      m=inf.read_memory(ve['addr'], env_len)
      buf = m.tobytes()
      gdb.write('envs:\n'+str(buf)+'\n')

    def kmsg(self,arg, from_tty):
      def savefile(f,buf,len):
        i=0
        while i<len: 
          m=inf.read_memory(buf+i,  min(len-i,0x10000))
          f.write(m.tobytes())
          f.flush()
          i=i+0x10000
        
      argv = gdb.string_to_argv(arg)
      argc = len(argv)
      filename = argv[0]
      buf = gdb.lookup_symbol('log_buf')[0].value()
      buflen = gdb.lookup_symbol('log_buf_len')[0].value()
      log_start = gdb.lookup_symbol('log_start')[0]
      log_start = log_start.value() if log_start else 0
      log_end = gdb.lookup_symbol('log_end')[0]
      log_end = log_end.value() if log_end else 0
      logged_chars = gdb.lookup_symbol('logged_chars')[0]
      logged_chars = logged_chars.value() if logged_chars else 0
      inf = gdb.selected_inferior()
      f = open(filename,'wb')
      if log_start and argc == 1:
          loglen = ((log_end+buflen-1-log_start)&(buflen - 1))+1
          if loglen + (log_start&(buflen -1)) > buflen:
            savefile(f, buf+(log_start&(buflen-1)), buflen-(log_start&(buflen-1)))
            savefile(f, buf, (log_end&(buflen-1)))
          else:
            savefile(f, buf+(log_start&(buflen-1)), loglen)
      f.write('---whole messages---\n'.encode('utf8'))
      savefile(f, buf, buflen)
      f.close()

    def kmsg1(self,filename, from_tty):
      def savefile(f,buf,len):
        i=0
        while i<len: 
          m=inf.read_memory(buf+i,  min(len-i,0x10000))
          f.write(m.tobytes())
          f.flush()
          i=i+0x10000
        
      buf = gdb.lookup_symbol('log_buf')[0].value()
      buflen = gdb.lookup_symbol('log_buf_len')[0].value()
      log_start = gdb.lookup_symbol('log_first_idx')[0]
      log_start = log_start.value() if log_start else None
      log_end = gdb.lookup_symbol('log_next_idx')[0]
      log_end = log_end.value() if log_end else None
      inf = gdb.selected_inferior()
      f = open(filename,'wb')
      if log_start != None:
          loglen = ((log_end+buflen-1-log_start)&(buflen - 1))+1
          if loglen + (log_start&(buflen -1)) > buflen:
            savefile(f, buf+(log_start&(buflen-1)), buflen-(log_start&(buflen-1)))
            savefile(f, buf, (log_end&(buflen-1)))
          else:
            savefile(f, buf+(log_start&(buflen-1)), loglen)
      f.close()
      
    def kmsg2(self,filename, from_tty):
      def savefile(f,buf,len):
        i=0
        while i<len: 
          m=inf.read_memory(buf+i,  min(len-i,0x10000))
          f.write(m.tobytes())
          f.flush()
          i=i+0x10000
        
      buf = gdb.lookup_symbol('log_buf')[0].value()
      buflen = gdb.lookup_symbol('log_buf_len')[0].value()
      log_start = gdb.lookup_symbol('log_first_idx')[0]
      log_start = log_start.value() if log_start else None
      log_end = gdb.lookup_symbol('log_next_idx')[0]
      log_end = log_end.value() if log_end else None
      inf = gdb.selected_inferior()
      f = open(filename,'wb')
      if log_start != None:
          idx = log_start
          
          while 1:
            m=inf.read_memory(buf+idx,  16)
            b=m.tobytes()
            t,alen,tlen,dlen,fac,flag  = struct.unpack('=QHHHBB',b)
            if alen:
              m=inf.read_memory(buf+idx+16,  tlen)
              txt=m.tobytes().decode('utf8','ignore')
              f.write(("%d:%s\n" %(t, txt)).encode('utf8'))
            idx=idx+alen
            if alen == 0: idx = 0
            elif idx == log_end: break
          f.close()
    def pci_config_write(self,bus=0,dev=0,func=0,reg=0,val=0):
      if (bus==0):
        addr = (dev<<11)|(func<<8)|reg
        addrp = pci_type0_conf_addr|(addr&0xffff)
      else :
        addr = (bus<<16)|(dev<<11)|(func<<8)|reg
        addrp = pci_type1_conf_addr|addr
      inf = gdb.selected_inferior()
      b=struct.pack('I',val)
      m=inf.write_memory(addrp,  b)
    def pci_config_read(self,bus=0,dev=0,func=0,reg=0,cnt=1):
      if (bus==0):
        addr = (dev<<11)|(func<<8)|reg
        addrp = pci_type0_conf_addr|(addr&0xffff)
      else :
        addr = (bus<<16)|(dev<<11)|(func<<8)|reg
        addrp = pci_type1_conf_addr|addr
      inf = gdb.selected_inferior()
      b=[]
      for i in range(0,cnt):
       m=inf.read_memory(addrp,  4)
       b.append(*struct.unpack('I',m.tobytes()))
       addrp+=4
      return b
    def pci_list_bus(self,bus=0,depth=255,reg=0,cnt=9):
      if bus<depth:
        for i in range(32 if not bus else 1):
         vendor=self.pci_config_read(bus,i,0,0)[0]
         if vendor in (0xffffffff,0): continue
         misc = self.pci_config_read(bus,i,0,0xc)[0]
         n= 8 if misc&0x800000 else 1
         for j in range(n):
           vendor=self.pci_config_read(bus,i,j,0)[0]
           if vendor in (0xffffffff,0): continue
           sys.stdout.write("{}\t{}\t{}:\t".format(bus,i,j))
           #print(' '.join(map(lambda x:"0x%08x"%x,self.pci_config_read(bus,i,j,reg,cnt))))
           print(' '.join(map(hex,self.pci_config_read(bus,i,j,reg,cnt))))
           classt=self.pci_config_read(bus,i,j,8)[0]
           if (classt&0xff000000)!=0x06000000 and (classt&0xffff0000)!=0x0b300000: continue
           classt = self.pci_config_read(bus, i, j, 0x18, 1)[0]
           busno = (classt>>8)&0xff
           if busno!=0: self.pci_list_bus(busno, depth, reg, cnt)

def rb_parent(t):
   return gdb.Value(ulong(t['__rb_parent_color']) & ~3).cast(t.type)

def rb_next(t):
 if t['__rb_parent_color'] == ulong(t):
   return None
 if t['rb_right']:
   t=t['rb_right']
   while t['rb_left']:
     t=t['rb_left']
   return t
 while True:
     parent = rb_parent(t)
     if not parent or t != parent['rb_right']: break
     t = parent
 return parent

def rb_first(rt):
 n = rt['rb_node']
 if not n:
   return None
 while n['rb_left']:
   n = n['rb_left']
 return n

def rb_last(rt):
 n = rt['rb_node']
 if not n:
   return None
 while n['rb_right']:
   n = n['rb_right']
 return n

def entity_is_task(se):
   return not se['my_q']

def print_task(task):
     curr = (task['se']['cfs_rq']['curr'] == task['se'].address)
     se = task['se'].address
     tinfo = task['stack'].cast(gdb.lookup_type('struct thread_info').pointer())
     #__KSTK_TOS
     uregs = gdb.Value(int(task['stack'])+gdb.lookup_type('union thread_union').sizeof-32-gdb.lookup_type('struct pt_regs').sizeof).cast(gdb.lookup_type('struct pt_regs').pointer())
     sys.stdout.write("[%s:%#x vrt:%d s:%d] %d %d %s ra=%#x sp=%#x epc=%#x usp=%#x task=%#x tinfo=%#x uregs=%#x stat=%#x\n" %(("se", "SE")[curr], ulong(se), se['vruntime'], task['nvcsw'] + task['nivcsw'], task['pid'], task['parent']['pid'], task['comm'].string(),ulong(task['thread']['reg31']),ulong(task['thread']['reg29']),ulong(uregs['cp0_epc']),ulong((uregs['regs'][29])),ulong(task), ulong(tinfo), ulong(uregs), ulong(task['state'])))

def rb_dump(rt):
 qt=[]
 t=rb_first(rt)
 while t:
   se = container_of(t,'struct sched_entity','run_node')
   if entity_is_task(se):
     task = container_of(se,'struct task_struct','se')
     print_task(task)
   else :
     qt.append([se['my_q'], 0])
   t = rb_next(t)
 return qt

def cfs_dump(cfs, curr, depth):
 print("%s%d %d %#x, enter cgroup %#x" %  (("cfs","CFS")[curr], depth, cfs['min_vruntime'], ulong(cfs), ulong(cfs['tg'])))
 qt = []
 se = cfs['curr']
 if se:
   if entity_is_task(se):
     task = container_of(se,'struct task_struct','se')
     print_task(task)
   else :
     qt.append([se['my_q'], 1])

 qt += rb_dump(cfs['tasks_timeline'])
 while qt:
  t=qt.pop(0)
  cfs_dump(t[0], t[1], depth+1)


def rb_all(t):
 qt=[]
 if not t:
  return qt

 se = container_of(t,'struct sched_entity','run_node')
 if entity_is_task(se):
   task = container_of(se,'struct task_struct','se')
   print_task(task)
 else :
   #cfs_all(se['my_q'])
   qt.append([se['my_q'],0])

 if t['rb_left']:
   qt+=rb_all(t['rb_left'])

 if t['rb_right']:
   qt+=rb_all(t['rb_right'])
 return qt

def cfs_all(cfs, curr, depth):
 print("%s%d %#x, enter cgroup %#x" %  (("cfs","CFS")[curr], depth, ulong(cfs), ulong(cfs['tg'])))
 qt=[]
 se = cfs['curr']
 if se:
   if entity_is_task(se):
     task = container_of(se,'struct task_struct','se')
     print_task(task)
   else :
     qt.append([se['my_q'],1])

 qt += rb_all(cfs['tasks_timeline']['rb_node'])
 while qt:
  t=qt.pop(0)
  cfs_all(t[0], t[1],depth+1)

 


try:
  from gdb.unwinder import Unwinder
  
  class FrameId(object):
  
      def __init__(self, sp, pc):
          self._sp = sp
          self._pc = pc
  
      @property
      def sp(self):
          return self._sp
  
      @property
      def pc(self):
          return self._pc
  
  
  class TestUnwinder(Unwinder):
  
      def __init__(self):
          Unwinder.__init__(self, "test unwinder")
          self.char_ptr_t = gdb.lookup_type("unsigned char").pointer()
          self.char_ptr_ptr_t = self.char_ptr_t.pointer()
  
      def _read_word(self, address):
          return address.cast(self.char_ptr_ptr_t).dereference()
  
      def __call__(self, pending_frame):
          """Test unwinder written in Python.
  
          This unwinder can unwind the frames that have been deliberately
          corrupted in a specific way (functions in the accompanying
          py-unwind.c file do that.)
          This code is only on AMD64.
          On AMD64 $RBP points to the innermost frame (unless the code
          was compiled with -fomit-frame-pointer), which contains the
          address of the previous frame at offset 0. The functions
          deliberately corrupt their frames as follows:
                       Before                 After
                     Corruption:           Corruption:
                  +--------------+       +--------------+
          RBP-8   |              |       | Previous RBP |
                  +--------------+       +--------------+
          RBP     + Previous RBP |       |    RBP       |
                  +--------------+       +--------------+
          RBP+8   | Return RIP   |       | Return  RIP  |
                  +--------------+       +--------------+
          Old SP  |              |       |              |
  
          This unwinder recognizes the corrupt frames by checking that
          *RBP == RBP, and restores previous RBP from the word above it.
          """
          try:
              # NOTE: the registers in Unwinder API can be referenced
              # either by name or by number. The code below uses both
              # to achieve more coverage.
              if not mycmd['_bt_kernel'] and not mycmd['_bt_user']:
                 return None
              mycmd['_bt_kernel'] = None
              pc = mycmd['curtasks']['thread']['reg31']
              sp = mycmd['curtasks']['thread']['reg29']
              s8 = mycmd['curtasks']['thread']['reg30']
              s7 = mycmd['curtasks']['thread']['reg23']
              s6 = mycmd['curtasks']['thread']['reg22']
              s5 = mycmd['curtasks']['thread']['reg21']
              s4 = mycmd['curtasks']['thread']['reg20']
              s3 = mycmd['curtasks']['thread']['reg19']
              s2 = mycmd['curtasks']['thread']['reg18']
              s1 = mycmd['curtasks']['thread']['reg17']
              s0 = mycmd['curtasks']['thread']['reg16']
  
  
              frame_id = FrameId(
                  pending_frame.read_register('sp'),
                  pending_frame.read_register('pc'))
              unwind_info = pending_frame.create_unwind_info(frame_id)
              unwind_info.add_saved_register('pc', pc)
              unwind_info.add_saved_register('sp', sp)
              unwind_info.add_saved_register('s8', s8)
              unwind_info.add_saved_register('s7', s7)
              unwind_info.add_saved_register('s6', s6)
              unwind_info.add_saved_register('s5', s5)
              unwind_info.add_saved_register('s4', s4)
              unwind_info.add_saved_register('s3', s3)
              unwind_info.add_saved_register('s2', s2)
              unwind_info.add_saved_register('s1', s1)
              unwind_info.add_saved_register('s0', s0)
              return unwind_info
          except (gdb.error, RuntimeError):
              return None
  
  gdb.unwinder.register_unwinder(None, TestUnwinder(), True)
except Exception:
  pass


class MycmdCommand_ls(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd ls', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        self.ls(arg,from_tty)

class MycmdCommand_get(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd get', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)
    def invoke(self, arg, from_tty):
        argv = gdb.string_to_argv(arg)
        l = int(argv[1],0) if len(argv)>1 else 0x100000000
        self.get(argv[0],0,l)

class MycmdCommand_put(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd put', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)
    def invoke(self, arg, from_tty):
        argv = gdb.string_to_argv(arg)
        l = int(argv[1],0) if len(argv)>1 else -1
        self.get(argv[0],1,l)

class MycmdCommand_dump(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd dump', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)
    def invoke(self, arg, from_tty):
        argv = gdb.string_to_argv(arg)
        l = int(argv[1],0) if len(argv)>1 else -1
        mode = int(argv[2],0) if len(argv)>2 else 2
        self.get(argv[0], mode, l)

class MycmdCommand_task(MycmdCommand, gdb.Function):
    def __init__(self,mycmd):
        self.data = mycmd.data
	
        gdb.Function.__init__ (self, "task")
        gdb.Command.__init__(self, 'mycmd task', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)
    def invoke(self, arg, from_tty=0):
        self.task()
        if type(arg) != gdb.Value:
          return self['curtasks'][arg]

class MycmdCommand_tasks(MycmdCommand, gdb.Function):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Function.__init__ (self, "tasks")
        gdb.Command.__init__(self, 'mycmd tasks', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)
    def invoke(self, arg, from_tty=0):
        if type(arg) != gdb.Value:
          self.tasks()
        else :
           arg = ulong(arg)
           return self['tasks'][arg][0]

class MycmdCommand_modules(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd modules', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)
    def invoke(self, arg, from_tty):
        self.modules()

class MycmdCommand_modules0(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd modules0', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)
    def invoke(self, arg, from_tty):
        self.modules0()

class MycmdCommand_modules24(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd modules24', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)
    def invoke(self, arg, from_tty):
        self.modules24()

class MycmdCommand_vma(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd vma', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)
    def invoke(self, arg, from_tty):
        self.vma()

class MycmdCommand_pidsel(MycmdCommand, gdb.Function):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Function.__init__ (self, "pidsel")
        gdb.Command.__init__(self, 'mycmd pidsel', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)
    def invoke(self, arg, from_tty=0):
        if type(arg) == str or type(arg) == unicode:
          arg = int(arg,0)
          self.pidsel(arg)
        else :
          arg = ulong(arg)
          return self['tasks'][arg][0]

class MycmdCommand_tasksel(MycmdCommand, gdb.Function):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Function.__init__ (self, "tasksel")
        gdb.Command.__init__(self, 'mycmd tasksel', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)
    def invoke(self, arg, from_tty=0):
        if type(arg) == str or type(arg) == unicode:
          arg = int(arg,0)
        else :
          arg = ulong(arg)
        self.tasksel(arg)
        return self['curtask']

class MycmdCommand_fds(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd fds', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        self.fds()

class MycmdCommand_interrupts(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd interrupts', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        self.interrupts()

class MycmdCommand_bt_panic(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd bt_panic', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        self.switch_panic()
        gdb.execute('bt', True, False)

class MycmdCommand_bt_exception(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd bt_exception', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        if arg:
          self.switch_exception(int(arg,0))
          gdb.execute('bt', True, False)
        else :
          self.switch_exception(ulong(self['irq_regs()']))
          gdb.execute('bt', True, False)
           

class MycmdCommand_bt_kernel(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd bt_kernel', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        if not arg:
          self.switch_kernel()
          gdb.execute('bt', True, False)
        else :
          for i in self['tasks']:
            self.pidsel(i)
            print('%d/%d: %s\n' % (i, self['curtask']['parent']['pid'], self['curtask']['comm'].string()))
            self.switch_kernel()
            gdb.execute('bt', True, False)

class MycmdCommand_bt_user(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd bt_user', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        if not arg:
          self.switch_user()
          gdb.execute('bt', True, False)
        else :
          for i in self['tasks']:
            self.pidsel(i)
            print('%d: %s\n' % (i,self['curtask']['comm'].string()))
            self.switch_user()
            gdb.execute('bt', True, False)

class MycmdCommand_save(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd save', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        self.regs_save()

class MycmdCommand_restore(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd restore', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        self.regs_restore()


class MycmdCommand_cmdline(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd cmdline', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        self.cmdline()

class MycmdCommand_vm(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd vm', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        v=self.accessvm(int(arg,0)) 
        for i in v:
          gdb.write(i+':0x%x, ' % v[i])
        gdb.write('\n')

class MycmdCommand_savevm(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd savevm', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        argv = gdb.string_to_argv(arg)
        argc = len(argv)
        if argc!=3: return
        vaddr = int(argv[1],0)
        vlen = int(argv[2],0)

        f=open(argv[0],'wb')
        inf = gdb.selected_inferior()
        
        while vlen: 
         v=self.accessvm(vaddr) 
         if not v['valid']: break
         once = min(v['len'], vlen); 
         m = inf.read_memory(v['addr'], once)
         f.write(m.tobytes())
         vlen -= once
         vaddr += once
        f.close()

class MycmdCommand_probe_pagesize(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd probe_pagesize', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        if 'pagesize' in mycmd.data:
          del mycmd.data['pagesize']
        print('pagesize is ' + str(mycmd['pagesize']))

class MycmdCommand_kmsg(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd kmsg', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        self.kmsg(arg,from_tty)

class MycmdCommand_kmsg1(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd kmsg1', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        self.kmsg1(arg,from_tty)

class MycmdCommand_kmsg2(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd kmsg2', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        self.kmsg2(arg,from_tty)

class MycmdCommand_lspci(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd lspci', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        self.pci_list_bus(*map(int,gdb.string_to_argv(arg)))

class MycmdCommand_pcicfgread(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd pcicfgread', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
           v=self.pci_config_read(*map(lambda x: int(x,0),gdb.string_to_argv(arg)))
           print(' '.join(map(hex,v)))

class MycmdCommand_pcicfgwrite(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd pcicfgwrite', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        self.pci_config_write(*map(lambda x: int(x,0),gdb.string_to_argv(arg)))

class MycmdCommand_containerof(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd containerof', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        argv = gdb.string_to_argv(arg)
        if not argv:
           print("mycmd containerof 0x89000000 'struct module' list")
           return
        (p,stype,member) = argv[:3]
        t=gdb.lookup_type(stype).pointer()
        z=gdb.Value(0).cast(t) 
        for i in member.split('.'):
          z=z[i]
        x=gdb.Value(int(gdb.parse_and_eval(p))-int(z.address)).cast(t)
        gdb.execute("p/x (%s *)0x%x" % (stype, ulong(x)))
        #print(("(%s *)0x%x" % (stype, ulong(x))))

class MycmdCommand_rq_dump(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd rq_dump', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        
        cpu = int(arg,0)
        __per_cpu_offset = gdb.lookup_global_symbol('__per_cpu_offset')
        rq = gdb.Value(__per_cpu_offset.value()[cpu] + ulong(gdb.lookup_global_symbol('runqueues').value().address)).cast(gdb.lookup_type('struct rq').pointer())
        cfs = rq['cfs'].address
        cfs_dump(cfs, 1, 0)

class MycmdCommand_rq_dump1(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd rq_dump1', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        
        cpu = int(arg,0)
        __per_cpu_offset = gdb.lookup_global_symbol('__per_cpu_offset')
        rq = gdb.Value(__per_cpu_offset.value()[cpu] + ulong(gdb.lookup_global_symbol('runqueues').value().address)).cast(gdb.lookup_type('struct rq').pointer())
        cfs = rq['cfs'].address
        cfs_all(cfs, 1, 0)


class Myfunc_container_of (gdb.Function, MycmdCommand):
  """Return string to greet someone.
Takes a name as argument."""

  def __init__ (self, mycmd):
    self.data = mycmd.data
    super (Myfunc_container_of, self).__init__ ("container_of")

  def invoke (self, p,stype,member):
    return container_of(p,stype.string('utf8'),member.string('utf8'))


class Myfunc_print_task (gdb.Function, MycmdCommand):
  """Return string to greet someone.
Takes a name as argument."""

  def __init__ (self, mycmd):
    self.data = mycmd.data
    gdb.Function.__init__ (self, "print_task")

  def invoke (self, task):
    print_task(task)
    return task

class Myfunc_python (gdb.Function, MycmdCommand):
  """Return string to greet someone.
Takes a name as argument."""

  def __init__ (self, mycmd):
    self.data = mycmd.data
    super (Myfunc_python, self).__init__ ("python")

  def invoke (self, arg):
    return eval(arg.string())



def cont_handler(event):
    if 'tasks' in mycmd.data:
      mycmd.regs_restore()
      del mycmd.data['tasks']
      del mycmd.data['curtasks']

mycmd = MycmdCommand()
MycmdCommand_ls(mycmd)
MycmdCommand_get(mycmd)
MycmdCommand_put(mycmd)
MycmdCommand_dump(mycmd)
MycmdCommand_task(mycmd)
MycmdCommand_tasks(mycmd)
MycmdCommand_modules(mycmd)
MycmdCommand_modules0(mycmd)
MycmdCommand_modules24(mycmd)
MycmdCommand_vma(mycmd)
MycmdCommand_pidsel(mycmd)
MycmdCommand_tasksel(mycmd)
MycmdCommand_fds(mycmd)
MycmdCommand_interrupts(mycmd)
MycmdCommand_bt_panic(mycmd)
MycmdCommand_bt_exception(mycmd)
MycmdCommand_bt_kernel(mycmd)
MycmdCommand_bt_user(mycmd)
MycmdCommand_save(mycmd)
MycmdCommand_restore(mycmd)
MycmdCommand_cmdline(mycmd)
MycmdCommand_vm(mycmd)
MycmdCommand_savevm(mycmd)
MycmdCommand_probe_pagesize(mycmd)
MycmdCommand_kmsg(mycmd)
MycmdCommand_kmsg1(mycmd)
MycmdCommand_kmsg2(mycmd)
MycmdCommand_lspci(mycmd)
MycmdCommand_pcicfgread(mycmd)
MycmdCommand_pcicfgwrite(mycmd)
MycmdCommand_containerof(mycmd)
MycmdCommand_rq_dump(mycmd)
MycmdCommand_rq_dump1(mycmd)
Myfunc_container_of(mycmd)
Myfunc_print_task(mycmd)
Myfunc_python(mycmd)
try:
  gdb.execute('set loggin on ' + time.strftime('%Y%m%d%H%M-gdb.log',time.localtime()))
  gdb.execute('set height 0')
  gdb.execute(gdbscript)
except Exception:
  pass
try:
  gdb.events.cont.connect(cont_handler)
except Exception:
  pass

