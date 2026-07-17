File { 
   Grid    = "@tdr@"
   Plot    = "@tdrdat@"
   Current = "@plot@"
   Output  = "@log@"
}

Electrode {
   { Name="source"    Voltage=0.0 }
   { Name="drain"     Voltage=0.0 }
   { Name="substrate" Voltage=0.0 }

   { Name="gateS"     Voltage=0.0 Workfunction=@Wf_S@ }
   { Name="gateD"     Voltage=0.0 Workfunction=@Wf_D@ }
}

Physics {
   EffectiveIntrinsicDensity( OldSlotboom )
}

Physics( Material="Silicon" ) {
   Mobility(
      PhuMob
      HighFieldSaturation
      Enormal
   )

   Recombination(
      SRH( DopingDependence )
   )
}

Math { 
   Extrapolate
   Iterations=20
   ExitOnFailure
}

Solve {
   Coupled( Iterations=100 ) { Poisson }
   Coupled { Poisson Electron Hole }

   #------------------------------------------------------------
   # 1) Low Vd Id-Vg sweep
   #------------------------------------------------------------

   Quasistationary(
      InitialStep=0.1
      Increment=1.5
      MinStep=1e-5
      MaxStep=1
      Goal { Name="drain" Voltage=@Vd_Low@ }
   ) {
      Coupled { Poisson Electron Hole }
   }

   NewCurrentPrefix="IdVg_Low_"

   Quasistationary(
      DoZero
      InitialStep=0.01
      Increment=1.5
      MinStep=1e-5
      MaxStep=0.05
      Goal { Name="gateS" Voltage=2.5 }
      Goal { Name="gateD" Voltage=2.5 }
   ) {
      Coupled { Poisson Electron Hole }
   }

   #------------------------------------------------------------
   # 2) Return gate voltage to 0 V before high Vd sweep
   #------------------------------------------------------------

   Quasistationary(
      InitialStep=0.05
      Increment=1.5
      MinStep=1e-5
      MaxStep=0.1
      Goal { Name="gateS" Voltage=0.0 }
      Goal { Name="gateD" Voltage=0.0 }
   ) {
      Coupled { Poisson Electron Hole }
   }

   #------------------------------------------------------------
   # 3) High Vd Id-Vg sweep
   #------------------------------------------------------------

   Quasistationary(
      InitialStep=0.1
      Increment=1.5
      MinStep=1e-5
      MaxStep=1
      Goal { Name="drain" Voltage=@Vd_High@ }
   ) {
      Coupled { Poisson Electron Hole }
   }

   NewCurrentPrefix="IdVg_High_"

   Quasistationary(
      DoZero
      InitialStep=0.01
      Increment=1.5
      MinStep=1e-5
      MaxStep=0.05
      Goal { Name="gateS" Voltage=2.5 }
      Goal { Name="gateD" Voltage=2.5 }
   ) {
      Coupled { Poisson Electron Hole }
   }
}
