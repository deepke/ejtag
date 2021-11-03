import re, sys, os, gdb, math, struct, time
try:
 gdb.execute('set mips abi o32')
 gdb.execute('set heuristic-fence-post 1024')
 gdb.execute('set python print-stack full')
except Exception as e:
 print(e)

if sys.version_info[0]<3: int = long 

def ulong(x):
   return int(x) & longmask
def uint(x):
   return int(x) & 0xffffffff

def container_of(p,stype,member):
   t=gdb.lookup_type(stype).pointer()
   z=gdb.Value(0).cast(t) 
   for i in member.split('.'):
     z=z[i]
   return gdb.Value(int(p)-int(z.address)).cast(t)

pgdorder = 0

btypes = { 1:"PLB", 2:"VME", 3:"PCI", 4:"PCIX", 5:"PCIEXPRESS",
           6:"HYPERTRANSPORT",  7:"RAPIDIO", 8:"MII", 
           9:"VIRTUAL", 10:"MF", 11:"USB_EHCI", 
           12:"USB_OHCI", 13:"USB_UHCI", 14:"USB_HUB", 
           15:"USB_SYNOPSYSHCI", 20:"I2C", 21:"SPI" } 
barTypes = [ "none", "IO space", "memory mapped", "special" ];
expgoff = { "epc":-0x178, "at":-0x108, "t7":-0x158, "t8":-0x160, "t9":-0x168, "sr":-0x190,"cr":-0x188}

class MycmdCommand(gdb.Command):
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
        self.data['u32_ptr'] = gdb.lookup_type("unsigned int").pointer()
        self.data['esf_t'] = gdb.lookup_global_symbol('excExcHandle').value().type.fields()[1].type
  
    def _read_pointer(self, address):
        return ulong(gdb.Value(address).cast(self['char_ptr_ptr_t']).dereference())
    def _read_u32(self, address):
        return int(gdb.Value(address).cast(self.data['u32_ptr']).dereference())
    def __getitem__(self,key):
        if type(key) != str: raise Exception('error no key')
        if key[-1] != ')' and key in self.data: return self.data[key]
        elif key == 'linuxver': return self.linuxver()
        elif key == 'tasks':
           self.tasks(False)
        elif key == 'curtasks':
           self.get_curtasks()
        elif key == 'isrs':
           self.interrupts(False)
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

    def pci_config_write(self,bus=0,dev=0,func=0,reg=0,val=0):
      if (bus==0):
        addr = (dev<<11)|(func<<8)|reg
        addrp = 0xffffffffba000000|(addr&0xffff)
      else :
        addr = (bus<<16)|(dev<<11)|(func<<8)|reg
        addrp = 0xffffffffbb000000|addr
      inf = gdb.selected_inferior()
      b=struct.pack('I',val)
      m=inf.write_memory(addrp,  b)

    def pci_config_read(self,bus=0,dev=0,func=0,reg=0,cnt=1):
      if (bus==0):
        addr = (dev<<11)|(func<<8)|reg
        addrp = 0xffffffffba000000|(addr&0xffff)
      else :
        addr = (bus<<16)|(dev<<11)|(func<<8)|reg
        addrp = 0xffffffffbb000000|addr
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

    def regs_save(self):
     if self['_regs']: return

     fm = gdb.newest_frame()
     regs={}
     for i in range(32):
       regs[i] = fm.read_register(str(i))
     self['_regs'] = regs
     regs['pc'] = fm.read_register('pc')

    def regs_restore(self):
     if not self['_regs']: return
     for i in range(32):
       gdb.execute('set $r%d=%#x'%(i,ulong(self['_regs'][i]))) 
     gdb.execute('set $pc=%#x'%(ulong(self['_regs']['pc']))) 
     self['_regs'] = None

    def switch_kernel(self, bt=1):
     areWeNested = self._read_u32(-0x400)
     if not areWeNested:
        return None
     epc = self._read_u32(expgoff['epc'])
     cause = self._read_u32(expgoff['cr'])
     sr = self._read_u32(expgoff['sr'])
     sp = ulong(gdb.Value(gdb.newest_frame().read_register("sp")))
     for i in range(0,0x1000,4):
       esf = gdb.Value(sp+i).cast(self.data['esf_t'])
       if epc == uint(esf['esfRegs']['pc']) and sr == uint(esf['esfRegs']['sr']) and cause == uint(esf['cause']):
         break
       esf = None
     if not esf:
       return None

     if bt:
        self.regs_save()
        for i in range(1,32):
          gdb.execute('set $r%d=%#x'%(i,ulong(esf['esfRegs']['gpreg'][i]))) 
        gdb.execute('set $pc=%#x'%(ulong(esf['esfRegs']['pc']))) 
     return esf
     
    def switch_exception(self, cpu, bt=1):
     vxKernelVars = gdb.lookup_global_symbol('vxKernelVars').value().cast(gdb.lookup_type('struct windVars').array(31).pointer())
     tcb = vxKernelVars[cpu]['vars']['cpu_taskIdCurrent']
     if not tcb['excCnt']:
        return None
     esf = gdb.Value(int(tcb['pExcStackBase']) - self.data['esf_t'].target().sizeof).cast(self.data['esf_t'])

     if bt:
        self.regs_save()
        for i in range(1,32):
          gdb.execute('set $r%d=%#x'%(i,ulong(esf['esfRegs']['gpreg'][i]))) 
        gdb.execute('set $pc=%#x'%(ulong(esf['esfRegs']['pc']))) 
     return esf

    def switch_interrupts(self, cpu, bt):
     vxKernelVars = gdb.lookup_global_symbol('vxKernelVars').value().cast(gdb.lookup_type('struct windVars').array(31).pointer())
     if not vxKernelVars[cpu]['vars']['cpu_intCnt']:
       return None
     esf = gdb.Value(int(vxKernelVars[cpu]['vars']['cpu_vxIntStackBase']) - self.data['esf_t'].target().sizeof).cast(self.data['esf_t'])

     if bt:
        self.regs_save()
        for i in range(1,32):
          gdb.execute('set $r%d=%#x'%(i,ulong(esf['esfRegs']['gpreg'][i]))) 
        gdb.execute('set $pc=%#x'%(ulong(esf['esfRegs']['pc']))) 
     return esf

    def switch_task(self, i):
     self.regs_save()
     tcb = self['tasks'][i]

     for i in range(1,32):
       gdb.execute('set $r%d=%#x'%(i,ulong(tcb['regs']['gpreg'][i]))) 
     gdb.execute('set $pc=%#x'% ulong(tcb['regs']['pc'])) 


    def tasks(self,show=1):
       vxCpuConfigured = int(gdb.lookup_global_symbol('vxCpuConfigured').value())
       vxKernelVars = gdb.lookup_global_symbol('vxKernelVars').value().cast(gdb.lookup_type('struct windVars').array(31).pointer())
       curtcbs = []
       tcbs = {}
       for i in range(vxCpuConfigured):
         curtcbs.append(vxKernelVars[i]['vars']['cpu_taskIdCurrent'])
       cur = curtcbs[0]
       taskClassId = gdb.lookup_global_symbol('taskClassId').value().cast(gdb.lookup_type('struct wind_class').pointer())
       head = taskClassId['objPrivList']['head']
       savedhead=head
       i=0
       objcore_t = gdb.lookup_type('struct wind_obj').pointer()
       
       while head:
          tcb= gdb.Value(int(head)-int(gdb.Value(0).cast(objcore_t)['classNode'].address)).cast(cur.type)
          tcbs[i] = tcb 

          if show:
            curstr = "*<%d> "%curtcbs.index(tcb) if tcb in curtcbs else "     ";
            sys.stdout.write("%s %-2d: Name: %-16s Entry: %-36s pc: %-36s ra: %-36s\n" %(curstr, i, tcb['objCore']['name'].string(), tcb['entry'], tcb['regs']['pc'], tcb['regs']['gpreg'][31].cast(tcb['regs']['pc'].type)))
          i=i+1
          head = head['next']
          if int(head) == int(savedhead) :
            break

       self['tasks']=tcbs
       self['curtasks'] = curtcbs
    def get_curtasks(self):
       vxCpuConfigured = int(gdb.lookup_global_symbol('vxCpuConfigured').value())
       vxKernelVars = gdb.lookup_global_symbol('vxKernelVars').value().cast(gdb.lookup_type('struct windVars').array(31).pointer())
       curtcbs = []
       tcbs = {}
       for i in range(vxCpuConfigured):
         curtcbs.append(vxKernelVars[i]['vars']['cpu_taskIdCurrent'])
       self['curtasks'] = curtcbs
       return curtcbs
    def task(self):
       if 'curtasks' in self.data:
          del self.data['curtasks']
       vxKernelVars = gdb.lookup_global_symbol('vxKernelVars').value().cast(gdb.lookup_type('struct windVars').array(31).pointer())
       i=0
       for tcb in self['curtasks']:
          sys.stdout.write("Name: %-30s Entry: %s pc: %s ra: %s excCnt: %d intCnt: %d\n" %(tcb['objCore']['name'].string(), tcb['entry'], tcb['regs']['pc'], tcb['regs']['gpreg'][31].cast(tcb['regs']['pc'].type), tcb['excCnt'], vxKernelVars[i]['vars']['cpu_intCnt']))
          i=i+1
       areWeNested = self._read_u32(-0x400)
       if areWeNested:
         epc = self._read_u32(expgoff['epc'])
         cause = self._read_u32(expgoff['cr'])
         sr = self._read_u32(expgoff['sr'])
         sys.stdout.write("IntNested: %d epc:%s cause:%#x sr:%#x\n" % (int(areWeNested),gdb.Value(epc).cast(self.data['u32_ptr']),cause,sr))

    def interrupts(self,show=1):
       cid_t=gdb.lookup_type("struct wind_class").pointer()
       cidt = gdb.lookup_global_symbol('classIdTable').value().address.cast(cid_t.pointer())
       idx = int(gdb.lookup_global_symbol('windIsrClass').value())
       taskClassId = cidt[idx]
       head = taskClassId['objPrivList']['head']
       savedhead=head
       i=0
       objcore_t = gdb.lookup_type('struct wind_obj').pointer()
       isrid_t=gdb.lookup_type("struct wind_isr").pointer()
       isrs = {}
       
       while head:
          tcb= gdb.Value(int(head)-int(gdb.Value(0).cast(objcore_t)['classNode'].address)).cast(isrid_t)
          isrs[int(tcb['isrTag'])] = tcb
          if show:
             sys.stdout.write("Name: %-30s isrTag: %s count: 0x%08x handlerRtn: %s\n" %(tcb['objCore']['name'].string(), tcb['isrTag'], int(tcb['count']), tcb['handlerRtn']))
          i=i+1
          head = head['next']
          if int(head) == int(savedhead) :
            break
       self['isrs'] = isrs
       return isrs
    def showdev(self, pInst):
            sys.stdout.write("%s unit %d on %s @ %s with busInfo %s\n" % (
            "(null)" if not pInst['pName'] else pInst['pName'].string(), pInst['unitNumber'], btypes[int(pInst['busID'])], pInst, pInst['u']['pSubordinateBus']));
            for i in range(10):
                if (pInst['regBaseFlags'][i]):
                    sys.stdout.write("\t    BAR%d @ 0x%08x (%s)\n" % ( i, pInst['pRegBase'][i], barTypes[pInst['regBaseFlags'][i]]))
            sys.stdout.write("\t    pDrvCtrl @ %s\n" % pInst['pDrvCtrl']);
            if (pInst['pDriver']):
                sys.stdout.write("\t    associated driver @ %s\n" % pInst['pDriver']);
    def vxbdevs(self,show=1):
       sys.stdout.write("Registered Bus Types:\n");
       pbus = gdb.lookup_global_symbol('pBusListHead').value().cast(gdb.lookup_type('struct vxbBusTypeInfo').pointer())
       while pbus:
         sys.stdout.write("  %s @ %s\n" % (btypes[int(pbus['busID'])], pbus))
         pbus = pbus['pNext']
       sys.stdout.write("\n");

       sys.stdout.write("Registered Device Drivers:\n");
       pdrv = gdb.lookup_global_symbol('pDriverListHead').value().cast(gdb.lookup_type('struct vxbDevRegInfo').pointer())
       while pdrv:
         sys.stdout.write("  %s at %s on bus %s, funcs @ %s\n" % (pdrv['drvName'].string(), pdrv, btypes[int(pdrv['busID'])], pdrv['pDrvBusFuncs']))
         pdrv = pdrv['pNext']

       sys.stdout.write("Busses and Devices Present:\n")
       plb = gdb.lookup_global_symbol('pPlbBus').value().cast(gdb.lookup_type('struct vxbBusPresent').pointer())
       while plb:
          sys.stdout.write("  %s @ %s with bridge @ %s\n" % (btypes[int(plb['pBusType']['busID'])], plb, plb['pCtlr']));
          dev = plb['instList']
          while dev:
            self.showdev(dev)
            dev = dev['pNext']
          dev = plb['devList']
          while dev:
            self.showdev(dev)
            dev = dev['pNext']
          plb = plb['pNext']
    def vxipilist(self):
       sys.stdout.write("Registered Ipi Types:\n");
       ipi_t = gdb.lookup_type('struct vxIpiCntrlInit').pointer()
       plist = gdb.lookup_symbol('pVxIpiListHead')[0].value()['head']
       while plist:
         ipi = plist.cast(ipi_t)
         sys.stdout.write("*(%s)%s=%s\n" % (ipi_t,ipi, ipi.dereference()));
         plist = plist['next']
    def devs(self):
       sys.stdout.write("Registered devs:\n");
       ipi_t = gdb.lookup_type('struct dev_hdr').pointer()
       plist = gdb.lookup_symbol('iosDvList')[0].value().cast(gdb.lookup_type('struct _Vx_DL_LIST').pointer())['head']
       while plist:
         ipi = plist.cast(ipi_t)
         sys.stdout.write("*(%s)%s=%s\n" % (ipi_t,ipi, ipi.dereference()));
         plist = plist['next']
    def watchdogs(self):
       sys.stdout.write("Registered watchdogs:\n");
       ipi_t = gdb.lookup_type('struct dev_hdr').pointer()
       plist = gdb.lookup_symbol('tickQHead')[0].value()['pFirstNode']
       tcb_t = gdb.lookup_type('struct windTcb').pointer()
       task_class_id = gdb.lookup_symbol('taskClass')[0].value().address
       wdt_t = gdb.lookup_type('struct wdog').pointer()
       while plist:
         tcb = gdb.Value(int(plist) - int(gdb.Value(0).cast(tcb_t)['tickNode'].address)).cast(tcb_t)
         if tcb['objCore']['pObjClass'] == task_class_id:
           sys.stdout.write("*(%s)%s=%s\n" % (tcb_t,tcb, tcb['objCore']['name']));
         else :
           wdt = gdb.Value(int(plist) - int(gdb.Value(0).cast(wdt_t)['tickNode'].address)).cast(wdt_t)
           sys.stdout.write("*(%s)%s=%s\n" % (wdt_t, wdt, wdt['wdRoutine']))
         plist = plist['qPriv1'].cast(plist.type)
    def mipc_nodes(self, bn=0, nn=0, show=1):
       node_t = gdb.lookup_type('struct mipc_sm_node').pointer()
       bus_t = gdb.lookup_type('struct mipc_sm_bus').pointer()
       bus = gdb.lookup_global_symbol('mipcSmBuses').value().cast(bus_t)
       mipcaddr = gdb.lookup_global_symbol('mipcSmStartAddr').value()
       node_p = gdb.Value(mipcaddr + bus[bn]['nodesOffset']).cast(node_t)
       if show: 
         sys.stdout.write("*(%s)%#x=%s\n" % (node_t, int(node_p[nn].address), node_p[nn]))
       return node_p



class MycmdCommand_task(MycmdCommand, gdb.Function):
    def __init__(self,mycmd):
        self.data = mycmd.data
	
        gdb.Function.__init__ (self, "task")
        gdb.Command.__init__(self, 'mycmd task', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)
    def invoke(self, arg, from_tty=0):
        if type(arg) != gdb.Value:
          self.task()
        else :
          arg = ulong(arg)
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
           return self['tasks'][arg]

class MycmdCommand_interrupts(MycmdCommand, gdb.Function):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Function.__init__ (self, "interrupts")
        gdb.Command.__init__(self, 'mycmd interrupts', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)
    def invoke(self, arg, from_tty=0):
        if type(arg) != gdb.Value:
          self.interrupts()
        else :
           return self['isrs'][int(arg, 0)]

class MycmdCommand_vxbdevs(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd vxbdevs', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        self.vxbdevs()

class MycmdCommand_devs(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd devs', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        self.devs()

class MycmdCommand_mipc_nodes(MycmdCommand, gdb.Function):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd mipc_nodes', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)
        gdb.Function.__init__ (self, "mipc_nodes")

    def invoke(self, arg, from_tty=0):
        if type(arg) != gdb.Value:
          argv = gdb.string_to_argv(arg)
          self.mipc_nodes(int(argv[0]), int(argv[1]))
        else :
          return self.mipc_nodes(arg, 0, 0)

class MycmdCommand_ipilist(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd ipilist', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        self.vxipilist()

class MycmdCommand_watchdogs(MycmdCommand):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd watchdogs', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)

    def invoke(self, arg, from_tty):
        self.watchdogs()

class MycmdCommand_bt_kernel(MycmdCommand, gdb.Function):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd bt_kernel', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)
        gdb.Function.__init__ (self, "bt_kernel")

    def invoke(self, arg, from_tty=0):
        if type(arg) != gdb.Value:
           if self.switch_kernel(1):
             gdb.execute('bt', True, False)
        else :
           return self.switch_kernel(0)

class MycmdCommand_bt_interrupts(MycmdCommand, gdb.Function):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd bt_interrupts', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)
        gdb.Function.__init__ (self, "bt_interrupts")

    def invoke(self, arg, from_tty=0):
        if type(arg) != gdb.Value:
          cpu = int(arg, 0) if len(arg) else gdb.selected_thread().num - 1
          if self.switch_interrupts(cpu, 1):
            gdb.execute('bt', True, False)
        else :
          cpu = int(arg)
          return self.switch_interrupts(cpu, 0)

class MycmdCommand_bt_exception(MycmdCommand, gdb.Function):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd bt_exception', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)
        gdb.Function.__init__ (self, "bt_exception")

    def invoke(self, arg, from_tty=0):
        if type(arg) != gdb.Value:
           cpu = int(arg, 0) if len(arg) else gdb.selected_thread().num - 1
           if self.switch_exception(cpu, 1):
             gdb.execute('bt', True, False)
        else :
           cpu = int(arg)
           return self.switch_exception(cpu, 0)
         

class MycmdCommand_bt_task(MycmdCommand, gdb.Function):
    def __init__(self,mycmd):
        self.data = mycmd.data
        gdb.Command.__init__(self, 'mycmd bt_task', gdb.COMMAND_DATA,
                             gdb.COMPLETE_NONE)
        gdb.Function.__init__ (self, "bt_task")

    def invoke(self, arg, from_tty=0):
        if type(arg) != gdb.Value:
           if not len(arg):
             for i in range(len(self['tasks'])):
               try:
                tcb = self['tasks'][i]
                sys.stdout.write("%-2d: Name: %-16s Entry: %-36s pc: %-36s ra: %-36s\n" %(i, tcb['objCore']['name'].string(), tcb['entry'], tcb['regs']['pc'], tcb['regs']['gpreg'][31].cast(tcb['regs']['pc'].type)))
                self.switch_task(i)
                gdb.execute('bt', True, False)
               except Exception as e:
                print(e.args)
                pass
           else :
               self.switch_task(int(arg, 0))
               gdb.execute('bt', True, False)
        else :
           return self['tasks'][int(arg)]

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

class Myfunc_container_of (gdb.Function, MycmdCommand):
  """Return string to greet someone.
Takes a name as argument."""

  def __init__ (self, mycmd):
    self.data = mycmd.data
    super (Myfunc_container_of, self).__init__ ("container_of")

  def invoke (self, p,stype,member):
    return container_of(p,stype.string('utf8'),member.string('utf8'))

class Myfunc_tasks (gdb.Function, MycmdCommand):
  """Return string to greet someone.
Takes a name as argument."""

  def __init__ (self, mycmd):
    self.data = mycmd.data
    super (Myfunc_tasks, self).__init__ ("tasks")

  def invoke (self, item):
    return self['tasks'][int(item)]

class Myfunc_task (gdb.Function, MycmdCommand):
  """Return string to greet someone.
Takes a name as argument."""

  def __init__ (self, mycmd):
    self.data = mycmd.data
    super (Myfunc_task, self).__init__ ("task")

  def invoke (self, item):
    return self['curtasks'][int(item)]

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
    if 'curtasks' in mycmd.data:
      del mycmd.data['curtasks']

mycmd = MycmdCommand()
MycmdCommand_task(mycmd)
MycmdCommand_tasks(mycmd)
MycmdCommand_bt_kernel(mycmd)
MycmdCommand_bt_interrupts(mycmd)
MycmdCommand_bt_exception(mycmd)
MycmdCommand_bt_task(mycmd)
MycmdCommand_save(mycmd)
MycmdCommand_restore(mycmd)
MycmdCommand_lspci(mycmd)
MycmdCommand_pcicfgread(mycmd)
MycmdCommand_pcicfgwrite(mycmd)
MycmdCommand_containerof(mycmd)
Myfunc_container_of(mycmd)
MycmdCommand_interrupts(mycmd)
MycmdCommand_vxbdevs(mycmd)
MycmdCommand_devs(mycmd)
MycmdCommand_ipilist(mycmd)
MycmdCommand_watchdogs(mycmd)
MycmdCommand_mipc_nodes(mycmd)
#Myfunc_tasks(mycmd)
#Myfunc_task(mycmd)
Myfunc_python(mycmd)
try:
  gdb.execute('set loggin on ' + time.strftime('%Y%m%d%H%M-gdb.log',time.localtime()))
  gdb.execute('set height 0')
except Exception:
  pass
try:
  gdb.events.cont.connect(cont_handler)
except Exception:
  pass

