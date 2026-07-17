(() => {
  const modal = document.getElementById('code-modal');
  const codeContent = document.getElementById('code-content');
  const codeLines = document.getElementById('code-lines');
  const fileName = document.getElementById('code-file-name');
  const githubCode = document.getElementById('github-code');
  const minimap = document.getElementById('code-minimap');
  const copyButton = document.getElementById('copy-code');
  const tabs = [...document.querySelectorAll('[data-code-tab]')];

  const files = {
    sprocess: {
      name: 'sprocess_lg0p1_initial.cmd',
      github: 'https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/coursework/sprocess_lg0p1_initial.cmd',
      code: `# Full MOSFET with Dual-Metal Gate
# y < 0 : source side
# y > 0 : drain side
# gateS : source-side low workfunction metal
# gateD : drain-side high workfunction metal

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

# Temporary Gate/Gap Implant-Block Cap
deposit Nitride type= anisotropic thickness= 0.020
mask name= gateCap left= -@Lg@/2 right= @Lg@/2
etch Nitride type= anisotropic thickness= 0.030 mask= gateCap

implant Arsenic dose= @LDD_Dose@ energy= @LDD_E@
deposit Nitride type= isotropic thickness= 0.3*@Lg@
etch Nitride type= anisotropic thickness= 0.35*@Lg@ mask= gateCap
implant Phosphorus dose= @SD_Dose@ energy= @SD_E@
diffuse time=0.5<s> temperature= 950

set GateCapStripThick [expr 0.020 + 0.40*@Lg@]
etch Nitride type= anisotropic thickness= $GateCapStripThick mask= keepOuterNitride
struct tdr= JH_n@node@_12_gate_cap_removed !Gas !interfaces`,
    },
    sdevice: {
      name: 'sdevice_initial.cmd',
      github: 'https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/coursework/sdevice_initial.cmd',
      code: `File {
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

   # Low Vd Id-Vg sweep
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

   # High Vd Id-Vg sweep
   Quasistationary(
      InitialStep=0.1
      Increment=1.5
      MinStep=1e-5
      MaxStep=1
      Goal { Name="drain" Voltage=@Vd_High@ }
   ) {
      Coupled { Poisson Electron Hole }
   }
}`,
    },
    svisual: {
      name: 'svisual_initial.tcl',
      github: 'https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/coursework/svisual_initial.tcl',
      code: `#setdep @node|sdevice@
puts "DEBUG: SVisual script started"

set n @node|sdevice@
set VgOff 0.0
set VgOn  2.5
set VdLow  @Vd_Low@
set VdHigh @Vd_High@

proc abs_list {input_list} {
  set output_list {}
  foreach v $input_list {
    lappend output_list [expr {abs($v) + 1.0e-30}]
  }
  return $output_list
}

proc nearest_y {xlist ylist x0} {
  set best_diff 1.0e99
  set best_y 0.0
  foreach x $xlist y $ylist {
    set diff [expr {abs($x - $x0)}]
    if {$diff < $best_diff} {
      set best_diff $diff
      set best_y $y
    }
  }
  return $best_y
}

proc format_value {value} {
  set avalue [expr {abs($value)}]
  if {$avalue == 0.0} {
    return [format %.2f $value]
  } elseif {$avalue >= 0.01 && $avalue < 1.0e6} {
    return [format %.2f $value]
  } else {
    return [format %.4e $value]
  }
}

proc wb_scalar {name value} {
  set value_fmt [format_value $value]
  puts "DOE: $name $value_fmt"
  if {[llength [info commands ft_scalar]] > 0} {
    ft_scalar $name $value_fmt
  }
}

proc extract_idvg_params {dataset_name VgOff VgOn label} {
  set Vgs     [get_variable_data "gateS OuterVoltage" -dataset $dataset_name]
  set Ids_raw [get_variable_data "drain TotalCurrent" -dataset $dataset_name]
  set Ids [abs_list $Ids_raw]

  # Manual gm extraction
  set gmList {}
  set gmXList {}
  set npts [llength $Vgs]

  for {set i 1} {$i < $npts} {incr i} {
    set x0 [lindex $Vgs [expr {$i-1}]]
    set x1 [lindex $Vgs $i]
    set y0 [lindex $Ids [expr {$i-1}]]
    set y1 [lindex $Ids $i]
    set dx [expr {$x1 - $x0}]
    if {[expr {abs($dx)}] > 1.0e-30} {
      set gm_i [expr {($y1 - $y0) / $dx}]
      lappend gmList $gm_i
    }
  }
}`,
    },
  };

  const escapeHtml = (value) => value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;');

  const highlight = (code) => {
    let html = escapeHtml(code);
    html = html.replace(/("[^"\n]*")/g, '<span class="tok-string">$1</span>');
    html = html.replace(/(^|\s)(#[^\n]*)/gm, '$1<span class="tok-comment">$2</span>');
    html = html.replace(/(@[A-Za-z0-9_|]+@|\$[A-Za-z_][A-Za-z0-9_]*)/g, '<span class="tok-variable">$1</span>');
    html = html.replace(/\b(0x[0-9A-Fa-f]+|\d+(?:\.\d+)?(?:e[+-]?\d+)?)\b/g, '<span class="tok-number">$1</span>');
    html = html.replace(/\b(set|proc|foreach|for|if|elseif|else|return|puts|lappend|incr|File|Electrode|Physics|Mobility|Recombination|Math|Solve|Coupled|Quasistationary|Goal)\b/g, '<span class="tok-keyword">$1</span>');
    html = html.replace(/\b(deposit|etch|mask|implant|diffuse|struct|contact|region|init|line|get_variable_data|format|expr|abs|llength|lindex)\b/g, '<span class="tok-command">$1</span>');
    html = html.replace(/\b(material|type|thickness|location|spacing|name|left|right|dose|energy|temperature|Voltage|Workfunction|InitialStep|Increment|MinStep|MaxStep|Iterations)\b/g, '<span class="tok-property">$1</span>');
    return html;
  };

  const renderMinimap = (code) => {
    const lines = code.split('\n');
    minimap.innerHTML = lines.map((line) => {
      const width = Math.max(8, Math.min(100, line.trim().length * 2));
      return `<div class="mini-line" style="width:${width}%"></div>`;
    }).join('');
  };

  const showFile = (key) => {
    const file = files[key] || files.sprocess;
    tabs.forEach((tab) => tab.classList.toggle('is-active', tab.dataset.codeTab === key));
    fileName.textContent = file.name;
    githubCode.href = file.github;
    codeContent.innerHTML = highlight(file.code);
    const count = file.code.split('\n').length;
    codeLines.textContent = Array.from({ length: count }, (_, index) => index + 1).join('\n');
    renderMinimap(file.code);
    codeContent.parentElement.scrollTop = 0;
    codeContent.parentElement.scrollLeft = 0;
  };

  const openModal = (key = 'sprocess') => {
    showFile(key);
    modal.classList.add('is-open');
    modal.setAttribute('aria-hidden', 'false');
    document.body.classList.add('modal-open');
    setTimeout(() => document.querySelector('.code-close')?.focus(), 30);
  };

  const closeModal = () => {
    modal.classList.remove('is-open');
    modal.setAttribute('aria-hidden', 'true');
    document.body.classList.remove('modal-open');
  };

  document.getElementById('open-code')?.addEventListener('click', () => openModal('sprocess'));
  document.querySelectorAll('[data-open-code]').forEach((button) => {
    button.addEventListener('click', () => openModal(button.dataset.openCode));
  });
  document.querySelectorAll('[data-close-code]').forEach((button) => {
    button.addEventListener('click', closeModal);
  });
  tabs.forEach((tab) => tab.addEventListener('click', () => showFile(tab.dataset.codeTab)));

  copyButton?.addEventListener('click', async () => {
    const active = document.querySelector('[data-code-tab].is-active')?.dataset.codeTab || 'sprocess';
    try {
      await navigator.clipboard.writeText(files[active].code);
      const original = copyButton.textContent;
      copyButton.textContent = 'Copied';
      setTimeout(() => { copyButton.textContent = original; }, 1200);
    } catch {
      copyButton.textContent = 'Copy failed';
    }
  });

  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && modal.classList.contains('is-open')) closeModal();
  });
})();
