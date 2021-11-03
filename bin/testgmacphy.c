typedef struct synopGMACDeviceStruct    
{
  ulong MacBase; 		         /* base address of MAC registers         */
  ulong DmaBase;         		 /* base address of DMA registers         */
  u32 PhyBase;          	 /* PHY device address on MII interface   */
} synopGMACdevice;
/*GmacGmiiAddr             = 0x0010,    GMII address Register(ext. Phy) Layout          */
enum GmacGmiiAddrReg      
{
  GmiiDevMask              = 0x0000F800,     /* (PA)GMII device address                 15:11     RW         0x00    */
  GmiiDevShift             = 11,

  GmiiRegMask              = 0x000007C0,     /* (GR)GMII register in selected Phy       10:6      RW         0x00    */
  GmiiRegShift             = 6,
  
  GmiiCsrClkMask	   = 0x0000001C,     /*CSR Clock bit Mask			 4:2			     */
  GmiiCsrClk5              = 0x00000014,     /* (CR)CSR Clock Range     250-300 MHz      4:2      RW         000     */
  GmiiCsrClk4              = 0x00000010,     /*                         150-250 MHz                                  */
  GmiiCsrClk3              = 0x0000000C,     /*                         35-60 MHz                                    */
  GmiiCsrClk2              = 0x00000008,     /*                         20-35 MHz                                    */
  GmiiCsrClk1              = 0x00000004,     /*                         100-150 MHz                                  */
  GmiiCsrClk0              = 0x00000000,     /*                         60-100 MHz                                   */

  GmiiWrite                = 0x00000002,     /* (GW)Write to register                      1      RW                 */
  GmiiRead                 = 0x00000000,     /* Read from register                                            0      */

  GmiiBusy                 = 0x00000001,     /* (GB)GMII interface is busy                 0      RW          0      */
};

/* GmacGmiiData            = 0x0014,    GMII data Register(ext. Phy) Layout             */
enum GmacGmiiDataReg      
{
  GmiiDataMask             = 0x0000FFFF,     /* (GD)GMII Data                             15:0    RW         0x0000  */
};

enum GmacRegisters              
{
  GmacConfig     	  = 0x0000,    /* Mac config Register                       */
  GmacFrameFilter  	  = 0x0004,    /* Mac frame filtering controls              */
  GmacHashHigh     	  = 0x0008,    /* Multi-cast hash table high                */
  GmacHashLow      	  = 0x000C,    /* Multi-cast hash table low                 */
  GmacGmiiAddr     	  = 0x0010,    /* GMII address Register(ext. Phy)           */
  GmacGmiiData     	  = 0x0014,    /* GMII data Register(ext. Phy)              */
  GmacFlowControl  	  = 0x0018,    /* Flow control Register                     */
  GmacVlan         	  = 0x001C,    /* VLAN tag Register (IEEE 802.1Q)           */
  
  GmacVersion     	  = 0x0020,    /* GMAC Core Version Register                */ 
  GmacWakeupAddr  	  = 0x0028,    /* GMAC wake-up frame filter adrress reg     */ 
  GmacPmtCtrlStatus  	  = 0x002C,    /* PMT control and status register           */ 
  
  GmacInterruptStatus	  = 0x0038,    /* Mac Interrupt ststus register	       */  
  GmacInterruptMask       = 0x003C,    /* Mac Interrupt Mask register	       */  
 
  GmacAddr0High    	  = 0x0040,    /* Mac address0 high Register                */
  GmacAddr0Low    	  = 0x0044,    /* Mac address0 low Register                 */
  GmacAddr1High    	  = 0x0048,    /* Mac address1 high Register                */
  GmacAddr1Low     	  = 0x004C,    /* Mac address1 low Register                 */
  GmacAddr2High   	  = 0x0050,    /* Mac address2 high Register                */
  GmacAddr2Low     	  = 0x0054,    /* Mac address2 low Register                 */
  GmacAddr3High    	  = 0x0058,    /* Mac address3 high Register                */
  GmacAddr3Low     	  = 0x005C,    /* Mac address3 low Register                 */
  GmacAddr4High    	  = 0x0060,    /* Mac address4 high Register                */
  GmacAddr4Low     	  = 0x0064,    /* Mac address4 low Register                 */
  GmacAddr5High    	  = 0x0068,    /* Mac address5 high Register                */
  GmacAddr5Low     	  = 0x006C,    /* Mac address5 low Register                 */
  GmacAddr6High    	  = 0x0070,    /* Mac address6 high Register                */
  GmacAddr6Low     	  = 0x0074,    /* Mac address6 low Register                 */
  GmacAddr7High    	  = 0x0078,    /* Mac address7 high Register                */
  GmacAddr7Low     	  = 0x007C,    /* Mac address7 low Register                 */
  GmacAddr8High    	  = 0x0080,    /* Mac address8 high Register                */
  GmacAddr8Low     	  = 0x0084,    /* Mac address8 low Register                 */
  GmacAddr9High    	  = 0x0088,    /* Mac address9 high Register                */
  GmacAddr9Low      	  = 0x008C,    /* Mac address9 low Register                 */
  GmacAddr10High          = 0x0090,    /* Mac address10 high Register               */
  GmacAddr10Low    	  = 0x0094,    /* Mac address10 low Register                */
  GmacAddr11High   	  = 0x0098,    /* Mac address11 high Register               */
  GmacAddr11Low    	  = 0x009C,    /* Mac address11 low Register                */
  GmacAddr12High   	  = 0x00A0,    /* Mac address12 high Register               */
  GmacAddr12Low     	  = 0x00A4,    /* Mac address12 low Register                */
  GmacAddr13High   	  = 0x00A8,    /* Mac address13 high Register               */
  GmacAddr13Low   	  = 0x00AC,    /* Mac address13 low Register                */
  GmacAddr14High   	  = 0x00B0,    /* Mac address14 high Register               */
  GmacAddr14Low        	  = 0x00B4,    /* Mac address14 low Register                */
  GmacAddr15High     	  = 0x00B8,    /* Mac address15 high Register               */
  GmacAddr15Low  	  = 0x00BC,    /* Mac address15 low Register                */
  GmacStatus		  = 0x00d8,    /*MAC status*/

  /*Time Stamp Register Map*/
  GmacTSControl	          = 0x0700,  /* Controls the Timestamp update logic                         : only when IEEE 1588 time stamping is enabled in corekit            */

  GmacTSSubSecIncr     	  = 0x0704,  /* 8 bit value by which sub second register is incremented     : only when IEEE 1588 time stamping without external timestamp input */

  GmacTSHigh  	          = 0x0708,  /* 32 bit seconds(MS)                                          : only when IEEE 1588 time stamping without external timestamp input */
  GmacTSLow   	          = 0x070C,  /* 32 bit nano seconds(MS)                                     : only when IEEE 1588 time stamping without external timestamp input */
  
  GmacTSHighUpdate        = 0x0710,  /* 32 bit seconds(MS) to be written/added/subtracted           : only when IEEE 1588 time stamping without external timestamp input */
  GmacTSLowUpdate         = 0x0714,  /* 32 bit nano seconds(MS) to be writeen/added/subtracted      : only when IEEE 1588 time stamping without external timestamp input */
  
  GmacTSAddend            = 0x0718,  /* Used by Software to readjust the clock frequency linearly   : only when IEEE 1588 time stamping without external timestamp input */
  
  GmacTSTargetTimeHigh 	  = 0x071C,  /* 32 bit seconds(MS) to be compared with system time          : only when IEEE 1588 time stamping without external timestamp input */
  GmacTSTargetTimeLow     = 0x0720,  /* 32 bit nano seconds(MS) to be compared with system time     : only when IEEE 1588 time stamping without external timestamp input */

  GmacTSHighWord          = 0x0724,  /* Time Stamp Higher Word Register (Version 2 only); only lower 16 bits are valid                                                   */
  //GmacTSHighWordUpdate    = 0x072C,  /* Time Stamp Higher Word Update Register (Version 2 only); only lower 16 bits are valid                                            */
  
  GmacTSStatus            = 0x0728,  /* Time Stamp Status Register                                                                                                       */
};

enum MiiRegisters
{
  PHY_CONTROL_REG           = 0x0000,		/*Control Register*/
  PHY_STATUS_REG            = 0x0001,		/*Status Register */
  PHY_ID_HI_REG             = 0x0002,		/*PHY Identifier High Register*/
  PHY_ID_LOW_REG            = 0x0003,		/*PHY Identifier High Register*/
  PHY_AN_ADV_REG            = 0x0004,		/*Auto-Negotiation Advertisement Register*/
  PHY_LNK_PART_ABl_REG      = 0x0005,		/*Link Partner Ability Register (Base Page)*/
  PHY_AN_EXP_REG            = 0x0006,		/*Auto-Negotiation Expansion Register*/
  PHY_AN_NXT_PAGE_TX_REG    = 0x0007,		/*Next Page Transmit Register*/
  PHY_LNK_PART_NXT_PAGE_REG = 0x0008,		/*Link Partner Next Page Register*/
  PHY_1000BT_CTRL_REG       = 0x0009,		/*1000BASE-T Control Register*/
  PHY_1000BT_STATUS_REG     = 0x000a,		/*1000BASE-T Status Register*/
  PHY_SPECIFIC_CTRL_REG     = 0x0010,		/*Phy specific control register*/
  PHY_SPECIFIC_STATUS_REG   = 0x0011,		/*Phy specific status register*/
  PHY_INTERRUPT_ENABLE_REG  = 0x0012,		/*Phy interrupt enable register*/
  PHY_INTERRUPT_STATUS_REG  = 0x0013,		/*Phy interrupt status register*/
  PHY_EXT_PHY_SPC_CTRL	    = 0x0014,		/*Extended Phy specific control*/
  PHY_RX_ERR_COUNTER	    = 0x0015,		/*Receive Error Counter*/
  PHY_EXT_ADDR_CBL_DIAG     = 0x0016,		/*Extended address for cable diagnostic register*/
  PHY_LED_CONTROL	    = 0x0018,		/*LED Control*/			
  PHY_MAN_LED_OVERIDE       = 0x0019,		/*Manual LED override register*/
  PHY_EXT_PHY_SPC_CTRL2     = 0x001a,		/*Extended Phy specific control 2*/
  PHY_EXT_PHY_SPC_STATUS    = 0x001b,		/*Extended Phy specific status*/
  PHY_CBL_DIAG_REG	    = 0x001c,		/*Cable diagnostic registers*/
};


#define DEFAULT_DELAY_VARIABLE  10
#define DEFAULT_LOOP_VARIABLE   10000

void plat_delay(u32 delay)
{
	while (delay--);
	return;
}

/* Error Codes */
#define ESYNOPGMACNOERR   0
#define ESYNOPGMACNOMEM   1
#define ESYNOPGMACPHYERR  2
#define ESYNOPGMACBUSY    3

static u32  synopGMACReadReg(ulong RegBase, u32 RegOffset)
{
	ulong addr;
	u32 data;
	addr = RegBase + (ulong)RegOffset;
	data = *(volatile u32 *)addr;
	return data;

}

/**
 * The Low level function to write to a register in Hardware.
 * 
 * @param[in] pointer to the base of register map  
 * @param[in] Offset from the base
 * @param[in] Data to be written 
 * \return  void 
 */
static void synopGMACWriteReg(ulong RegBase, u32 RegOffset, u32 RegData )
{
	ulong addr;
	addr = RegBase + (ulong)RegOffset;
	*(volatile u32 *)addr = RegData;
	return;
}


/**
  * Function to read the Phy register. The access to phy register
  * is a slow process as the data is moved accross MDI/MDO interface
  * @param[in] pointer to Register Base (It is the mac base in our case) .
  * @param[in] PhyBase register is the index of one of supported 32 PHY devices.
  * @param[in] Register offset is the index of one of the 32 phy register.
  * @param[out] u16 data read from the respective phy register (only valid iff return value is 0).
  * \return Returns 0 on success else return the error status.
  */
s32 synopGMAC_read_phy_reg(ulong RegBase,u32 PhyBase, u32 RegOffset, u16 * data )
{
u32 addr;
u32 loop_variable;
addr = ((PhyBase << GmiiDevShift) & GmiiDevMask) | ((RegOffset << GmiiRegShift) & GmiiRegMask) | GmiiCsrClk3;	//sw: add GmiiCsrClk 
addr = addr | GmiiBusy ; //Gmii busy bit

synopGMACWriteReg(RegBase,GmacGmiiAddr,addr); //write the address from where the data to be read in GmiiGmiiAddr register of synopGMAC ip

        for(loop_variable = 0; loop_variable < DEFAULT_LOOP_VARIABLE; loop_variable++){ //Wait till the busy bit gets cleared with in a certain amount of time
                if (!(synopGMACReadReg(RegBase,GmacGmiiAddr) & GmiiBusy)){
               		 break;
                }
        plat_delay(DEFAULT_DELAY_VARIABLE);
        }
        if(loop_variable < DEFAULT_LOOP_VARIABLE)
               * data = (u16)(synopGMACReadReg(RegBase,GmacGmiiData) & 0xFFFF);
        else{
        printf("Error::: PHY not responding Busy bit didnot get cleared !!!!!!\n");
	return -ESYNOPGMACPHYERR;
        }
//sw	
#if SYNOP_REG_DEBUG
	printf("read phy reg: offset = 0x%x\tdata = 0x%x\n",RegOffset,*data);
#endif

return -ESYNOPGMACNOERR;
}

/**
  * Function to write to the Phy register. The access to phy register
  * is a slow process as the data is moved accross MDI/MDO interface
  * @param[in] pointer to Register Base (It is the mac base in our case) .
  * @param[in] PhyBase register is the index of one of supported 32 PHY devices.
  * @param[in] Register offset is the index of one of the 32 phy register.
  * @param[in] data to be written to the respective phy register.
  * \return Returns 0 on success else return the error status.
  */
s32 synopGMAC_write_phy_reg(ulong RegBase, u32 PhyBase, u32 RegOffset, u16 data)
{
u32 addr;
u32 loop_variable;

synopGMACWriteReg(RegBase,GmacGmiiData,data); // write the data in to GmacGmiiData register of synopGMAC ip

addr = ((PhyBase << GmiiDevShift) & GmiiDevMask) | ((RegOffset << GmiiRegShift) & GmiiRegMask) | GmiiWrite | GmiiCsrClk3;	//sw: add GmiiCsrclk

addr = addr | GmiiBusy ; //set Gmii clk to 20-35 Mhz and Gmii busy bit
 
synopGMACWriteReg(RegBase,GmacGmiiAddr,addr);
        for(loop_variable = 0; loop_variable < DEFAULT_LOOP_VARIABLE; loop_variable++){
                if (!(synopGMACReadReg(RegBase,GmacGmiiAddr) & GmiiBusy)){
                	break;
                }
        plat_delay(DEFAULT_DELAY_VARIABLE);
        }

        if(loop_variable < DEFAULT_LOOP_VARIABLE){
	return -ESYNOPGMACNOERR;
	}
        else{
        printf("Error::: PHY not responding Busy bit didnot get cleared !!!!!!\n");
	return -ESYNOPGMACPHYERR;
        }
#if SYNOP_REG_DEBUG
	printf("write phy reg: offset = 0x%x\tdata = 0x%x",RegOffset,data);
#endif
}

static int rtl88e1111_config_init(synopGMACdevice *gmacdev)
{
	int retval, err;
	u16 data;

	synopGMAC_read_phy_reg(gmacdev->MacBase,gmacdev->PhyBase,0x14,&data);
	data = data | 0x82;
	err = synopGMAC_write_phy_reg(gmacdev->MacBase,gmacdev->PhyBase,0x14,data);
	synopGMAC_read_phy_reg(gmacdev->MacBase,gmacdev->PhyBase,0x00,&data);
	data = data | 0x8000;
	err = synopGMAC_write_phy_reg(gmacdev->MacBase,gmacdev->PhyBase,0x00,data);

       /*init link and act indication leds*/
           synopGMAC_read_phy_reg((u32 *) gmacdev->MacBase, gmacdev->PhyBase,
                                  PHY_LED_CONTROL, &data);
       data = (data | 0x51) &0xf4ff;
           synopGMAC_write_phy_reg((u32 *) gmacdev->MacBase, gmacdev->PhyBase,
                                   PHY_LED_CONTROL, data);
	if (err < 0)
		return err;
	return 0;
}

static int alaska88e151x_config_init(synopGMACdevice *gmacdev)
{
	int err;
	u16 data;

	// reset phy
	err = synopGMAC_read_phy_reg(gmacdev->MacBase,gmacdev->PhyBase,0x0, &data);
	data = data | 0x8000;
	err = synopGMAC_write_phy_reg(gmacdev->MacBase,gmacdev->PhyBase,0x0,data);

	/*set led link stat*/
	synopGMAC_write_phy_reg(gmacdev->MacBase,gmacdev->PhyBase, 22, 3);
#ifdef LED_88E151X
	synopGMAC_write_phy_reg(gmacdev->MacBase,gmacdev->PhyBase, 16, LED_88E151X);
#else
	synopGMAC_write_phy_reg(gmacdev->MacBase,gmacdev->PhyBase, 16, 0x1038);
#endif
	synopGMAC_write_phy_reg(gmacdev->MacBase,gmacdev->PhyBase, 22, 0);

	if (err < 0)
		return err;
	return 0;
}

int init_phy(synopGMACdevice *gmacdev)
{
	u16 data2;
	u16 data3;
	synopGMAC_read_phy_reg(gmacdev->MacBase,gmacdev->PhyBase,2,&data2);
	synopGMAC_read_phy_reg(gmacdev->MacBase,gmacdev->PhyBase,3,&data3);

	if(data2 == 0x141 && ((data3 >> 10) == 0x3)){ //marvel ethernet phy
		if(((data3 >> 4) & 0x3f) == 0x0C){  //88E11
			/*set 88e1111 clock phase delay*/
			rtl88e1111_config_init(gmacdev);
		}else if(((data3 >> 4) & 0x3f) == 0x1D) { //88E15
			alaska88e151x_config_init(gmacdev);
		}
	} else if(data2 == 0x22) {
		synopGMAC_write_phy_reg(gmacdev->MacBase,gmacdev->PhyBase,0xc,0xf0f0);
		synopGMAC_write_phy_reg(gmacdev->MacBase,gmacdev->PhyBase,0xb,0x8104);
		synopGMAC_write_phy_reg(gmacdev->MacBase,gmacdev->PhyBase,0xb,0x104);
	}
		return 0;
}
synopGMACdevice gmacdev = {(int)0xbf020000,(int)0xbf021000, 0};

int mymain()
{
 init_phy(&gmacdev);
return 0;
}
