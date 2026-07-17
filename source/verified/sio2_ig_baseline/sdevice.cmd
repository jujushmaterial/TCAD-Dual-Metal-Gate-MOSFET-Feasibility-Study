File {
  Grid      = "@tdr@"
  Plot      = "@tdrdat@"
  Current   = "@plot@"
  Output    = "@log@"
  Parameter = "@parameter@"
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
  eBarrierTunneling "NLM_gateS"
  hBarrierTunneling "NLM_gateS"
  eBarrierTunneling "NLM_gateD"
  hBarrierTunneling "NLM_gateD"
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

Plot {
  eBarrierTunneling
  hBarrierTunneling
}

Math {
  Extrapolate
  Iterations=20
  ExitOnFailure

  NonLocal "NLM_gateS" (
    Electrode="gateS"
    Length=1e-6
    Digits=4
    EnergyResolution=1e-3
  )

  NonLocal "NLM_gateD" (
    Electrode="gateD"
    Length=1e-6
    Digits=4
    EnergyResolution=1e-3
  )
}

Solve {
  Coupled( Iterations=100 ) { Poisson }
  Coupled { Poisson Electron Hole }

  # Low-Vd Id-Vg / Ig-Vg sweep
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

  # Return gate voltage to zero
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

  # High-Vd Id-Vg / Ig-Vg sweep
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
