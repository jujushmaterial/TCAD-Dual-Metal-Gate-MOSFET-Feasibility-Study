# SProcess: SiO2 Dual-Metal Gate MOSFET baseline for Ig check

#header
#endheader

set GateCapThick 0.020
set GateCapEtch  0.030

line x location= 0    spacing= 0.01 tag= top
line x location= 0.15 spacing= 0.02
line x location= 1.0  spacing= 0.2  tag= bottom

line y location= -2*@Lg@    spacing= @Lg@       tag= left
line y location= -0.5*@Lg@  spacing= 0.05*@Lg@
line y location= 0.0        spacing= 0.02*@Lg@
line y location= 0.5*@Lg@   spacing= 0.05*@Lg@
line y location= 2*@Lg@     spacing= @Lg@       tag= right

region Silicon xlo= top xhi= bottom ylo= left yhi= right

init concentration= @NWell@ field= Boron slice.angle= 180 !DelayFullD
pdbSet Silicon Dopant DiffModel ChargedFermi
struct tdr= JH_n@node@_01_initialize !Gas !interfaces

pdbSet Oxide Grid perp.add.dist 0.01e-4
diffuse time= @GOxTime@ temperature= 950 O2
struct tdr= JH_n@node@_02_gate_oxidation !Gas !interfaces

set oxidelayer [lindex [layers y=0 Oxide] 1]
puts "DOE: tox [format %.4f [expr [lindex $oxidelayer 1] - [lindex $oxidelayer 0]]]"

# Source-side metal gate
deposit material= {Titanium} type= anisotropic thickness= 0.1
mask name= gateS left= -@Lg@/2 right= -@DMG_Gap@/2
etch material= {Titanium} type= anisotropic thickness= 0.12 mask= gateS
struct tdr= JH_n@node@_03_gateS_formation !Gas !interfaces

# Drain-side metal gate
deposit material= {Tungsten} type= anisotropic thickness= 0.1
mask name= gateD left= @DMG_Gap@/2 right= @Lg@/2
etch material= {Tungsten} type= anisotropic thickness= 0.12 mask= gateD
struct tdr= JH_n@node@_04_gateD_formation !Gas !interfaces

mask name= gateAll left= -@Lg@/2 right= @Lg@/2
etch Oxide type= anisotropic thickness= 0.02 mask= gateAll
struct tdr= JH_n@node@_05_gate_oxide_etch !Gas !interfaces

# Temporary gate/gap implant-block cap
deposit Nitride type= anisotropic thickness= 0.020
mask name= gateCap left= -@Lg@/2 right= @Lg@/2
etch Nitride type= anisotropic thickness= 0.030 mask= gateCap
struct tdr= JH_n@node@_06_gate_gap_cap !Gas !interfaces

implant Arsenic dose= @LDD_Dose@ energy= @LDD_E@
struct tdr= JH_n@node@_07_LDD_implant !Gas !interfaces

deposit Nitride type= isotropic thickness= 0.3*@Lg@
struct tdr= JH_n@node@_08_spacer_depo !Gas !interfaces
etch Nitride type= anisotropic thickness= 0.35*@Lg@ mask= gateCap
struct tdr= JH_n@node@_09_spacer_etch_cap_kept !Gas !interfaces

implant Phosphorus dose= @SD_Dose@ energy= @SD_E@
struct tdr= JH_n@node@_10_SD_implant !Gas !interfaces

diffuse time=0.5<s> temperature= 950
struct tdr= JH_n@node@_11_SD_anneal !Gas !interfaces

mask name= keepOuterNitride segments= { -2*@Lg@ -@Lg@/2  @Lg@/2 2*@Lg@ }
set GateCapStripThick [expr 0.020 + 0.40*@Lg@]
etch Nitride type= anisotropic thickness= $GateCapStripThick mask= keepOuterNitride
struct tdr= JH_n@node@_12_gate_cap_removed !Gas !interfaces

deposit Aluminum type= anisotropic thickness= 0.05
mask name= contact segments= { -2*@Lg@ -1.2*@Lg@  1.2*@Lg@ 2*@Lg@ }
etch Aluminum type= anisotropic thickness= 0.1 mask= contact
struct tdr= JH_n@node@_13_Al_contact !Gas !interfaces

# No reflect: the lateral DMG structure is not mirror-symmetric.
contact name= substrate bottom
contact name= source point y= -@Lg@*1.5 x= -0.010 replace
contact name= drain  point y=  @Lg@*1.5 x= -0.010 replace
contact name= gateS point y= -@Lg@*0.25 x= -0.050 replace
contact name= gateD point y=  @Lg@*0.25 x= -0.050 replace

struct tdr= n@node@ !Gas !interfaces
