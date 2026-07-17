---
layout: default
title: TCAD Source Code
---

# TCAD Source Code

프로젝트에서 사용한 Sentaurus command 전문을 연구 발전 단계별로 공개합니다. 아래 파일을 누르면 현재 페이지 위에 코드 뷰어가 열립니다.

---

## 1. 최종 발표의 기본 DMG 코드 세트

최종 발표의 scaling 및 parameter-screening 단계에서 사용한 기본 SProcess–SDevice–SVisual 흐름입니다.

<div class="code-action-grid">
  <button class="code-open-button" type="button" data-code-file="source/coursework/sprocess_lg0p1_initial.cmd" data-code-title="SProcess · lateral DMG 공정 구현">
    <strong>SProcess</strong><span>lateral DMG 공정 구현</span>
  </button>
  <button class="code-open-button" type="button" data-code-file="source/coursework/sdevice_initial.cmd" data-code-title="SDevice · Low/High-Vd Id–Vg sweep">
    <strong>SDevice</strong><span>Low/High-Vd Id–Vg sweep</span>
  </button>
  <button class="code-open-button" type="button" data-code-file="source/coursework/svisual_initial.tcl" data-code-title="SVisual · metric extraction">
    <strong>SVisual</strong><span>Vth, SS, Ion, Ioff, Ion/Ioff, DIBL extraction</span>
  </button>
</div>

이 세 파일은 같은 Workbench project에서 다음 순서로 사용되는 한 세트입니다.

```text
SProcess
→ TDR structure
→ SDevice Low/High-Vd Id–Vg
→ SVisual metric extraction
```

---

## 2. SiO₂ gate-leakage baseline

GateS와 GateD terminal current를 분리하고 gate tunneling을 비교한 코드 세트입니다.

<div class="code-action-grid">
  <button class="code-open-button" type="button" data-code-file="source/verified/sio2_ig_baseline/sprocess.cmd" data-code-title="SiO₂ baseline · SProcess">
    <strong>SProcess</strong><span>DMG structure와 gate/gap cap</span>
  </button>
  <button class="code-open-button" type="button" data-code-file="source/verified/sio2_ig_baseline/sdevice.cmd" data-code-title="SiO₂ baseline · SDevice">
    <strong>SDevice</strong><span>GateS/GateD NonLocal tunneling</span>
  </button>
  <button class="code-open-button" type="button" data-code-file="source/verified/sio2_ig_baseline/svisual.tcl" data-code-title="SiO₂ baseline · SVisual">
    <strong>SVisual</strong><span>Id와 gate-terminal current extraction</span>
  </button>
  <button class="code-open-button" type="button" data-code-file="source/verified/sio2_ig_baseline/sdevice.par" data-code-title="SiO₂ baseline · SDevice parameter">
    <strong>SDevice Parameter</strong><span>SiO₂ tunneling parameter</span>
  </button>
</div>

주요 추가 기능:

- GateS/GateD current extraction
- `IgTotal = |IgS| + |IgD|`
- Low-Vd/High-Vd gate-current 비교
- Thin-SiO₂ leakage 확인

---

## 3. High-K EOT 1.6 nm 및 gate-ratio 분석

High-K stack, GateS/GateD ratio parameterization, corrected Vtgm과 constant-current DIBL을 포함한 주 검증 세트입니다.

<div class="code-action-grid">
  <button class="code-open-button" type="button" data-code-file="source/verified/highk_eot1p6_gate_ratio/sprocess.cmd" data-code-title="High-K & Gate Ratio · SProcess">
    <strong>SProcess</strong><span>High-K stack과 GateS/GateD ratio</span>
  </button>
  <button class="code-open-button" type="button" data-code-file="source/verified/highk_eot1p6_gate_ratio/sdevice.cmd" data-code-title="High-K & Gate Ratio · SDevice">
    <strong>SDevice</strong><span>Gate current와 Low/High-Vd sweep</span>
  </button>
  <button class="code-open-button" type="button" data-code-file="source/verified/highk_eot1p6_gate_ratio/svisual.tcl" data-code-title="High-K & Gate Ratio · SVisual">
    <strong>SVisual</strong><span>corrected Vtgm, CC-DIBL, Id/Ig extraction</span>
  </button>
  <button class="code-open-button" type="button" data-code-file="source/verified/highk_eot1p6_gate_ratio/sdevice.par" data-code-title="High-K & Gate Ratio · SDevice parameter">
    <strong>SDevice Parameter</strong><span>SiO₂ IL/HfO₂ tunneling parameter</span>
  </button>
</div>

주요 추가 기능:

- SiO₂ interfacial layer/HfO₂ stack
- EOT 약 1.6 nm 유지
- GateS/GateD 길이 비율 parameterization
- GateS/GateD별 NonLocal tunneling mesh
- corrected Vtgm
- constant-current Vth
- signed/absolute DIBL과 valid flag

---

## 4. Variable-EOT extension

HfO₂ 두께를 EOT 목표값에 맞춰 계산하는 확장 세트입니다.

<div class="code-action-grid">
  <button class="code-open-button" type="button" data-code-file="source/extended/highk_eot_sweep/sprocess.cmd" data-code-title="Variable-EOT · SProcess">
    <strong>SProcess</strong><span>EOT target 기반 HfO₂ thickness 계산</span>
  </button>
  <button class="code-open-button" type="button" data-code-file="source/extended/highk_eot_sweep/sdevice.par" data-code-title="Variable-EOT · SDevice parameter">
    <strong>SDevice Parameter</strong><span>SiO₂ IL/HfO₂ tunneling parameter</span>
  </button>
  <button class="code-open-button" type="button" data-code-file="source/verified/highk_eot1p6_gate_ratio/sdevice.cmd" data-code-title="Variable-EOT reused · SDevice">
    <strong>SDevice</strong><span>verified High-K code 재사용</span>
  </button>
  <button class="code-open-button" type="button" data-code-file="source/verified/highk_eot1p6_gate_ratio/svisual.tcl" data-code-title="Variable-EOT reused · SVisual">
    <strong>SVisual</strong><span>corrected Vtgm, CC-DIBL, Id/Ig extraction</span>
  </button>
</div>

이 확장은 후속 연구 자산이며, 최종 학회 발표의 핵심 결과는 EOT ≈ 1.6 nm 조건을 사용했습니다.

---

## 공개 범위와 한계

공개된 코드는 프로젝트에서 실제 사용한 representative command 전문입니다. 동일한 절대값 재현에는 다음 조건이 필요합니다.

- Synopsys Sentaurus T-2022.03
- 유효한 license와 server environment
- 동일한 Workbench variable 등록
- 동일한 node dependency와 file prefix
- mesh, material parameter와 tunneling model 설정

코드와 결과의 정확한 연결은 [재현 방법과 코드 매핑](../appendix/reproducibility.html)에서 확인할 수 있습니다.
