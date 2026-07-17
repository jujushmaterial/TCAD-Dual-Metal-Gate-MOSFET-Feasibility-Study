---
layout: default
title: Reproducibility and Full TCAD Source
---

# Reproducibility and Full TCAD Source

[← 전체 연구](../study/index.html) · [데이터 신뢰성](./data_lineage_and_reliability.html) · [최종 발표](../presentation/README.html)

이 페이지는 발표자료의 각 연구 단계가 어떤 Sentaurus code set과 결과 데이터에 연결되는지 정리합니다.

---

## 1. Execution environment

- Synopsys Sentaurus T-2022.03
- Sentaurus Workbench
- SProcess
- SDevice
- SVisual
- Linux server accessed through MobaXterm

실행에는 유효한 Sentaurus license와 Workbench node/parameter 설정이 필요합니다.

---

## 2. Overall execution order

```text
Workbench variables
→ SProcess structure generation
→ TDR checkpoint inspection
→ SDevice Low-Vd / High-Vd simulation
→ Id–Vg and Ig–Vg output
→ SVisual metric extraction
→ DOE scalar comparison
→ portfolio CSV and figures
```

---

## 3. Code sets

| Code set | Purpose | Status | Related study |
|---|---|---|---|
| [`source/coursework/`](../source/coursework/README.html) | 최초 lateral DMG 구현 | Historical baseline | 연구 출발점 |
| [`source/verified/sio2_ig_baseline/`](../source/verified/sio2_ig_baseline/README.html) | SiO₂ DMG와 gate tunneling | Verified successful run | 발표 17장 |
| [`source/verified/highk_eot1p6_gate_ratio/`](../source/verified/highk_eot1p6_gate_ratio/README.html) | High-K, ratio, corrected Vtgm, CC-DIBL | Main verified set | 발표 18~23장 및 후속 검증 |
| [`source/extended/highk_eot_sweep/`](../source/extended/highk_eot_sweep/README.html) | variable-EOT 확장 | Successful extension | 발표 이후 확장 |

---

## 4. Main Workbench variables

### Geometry and process

- `Lg`
- `DMG_Gap`
- `DMG_RatioS`
- `NWell`
- `LDD_Dose`
- `LDD_E`
- `SD_Dose`
- `SD_E`

### Electrical conditions

- `Wf_S`
- `Wf_D`
- `Vd_Low`
- `Vd_High`

### Extended High-K study

- `EOT_Target`

---

## 5. Coursework code set

### Purpose

SimpleMOS 기반 nMOS에서 GateS와 GateD를 lateral direction으로 분리하고, Low/High-Vd Id–Vg와 초기 metrics를 추출한 출발점입니다.

### Files

- [`sprocess_lg0p1_initial.cmd`](../source/coursework/sprocess_lg0p1_initial.cmd)
- [`sdevice_initial.cmd`](../source/coursework/sdevice_initial.cmd)
- [`svisual_initial.tcl`](../source/coursework/svisual_initial.tcl)

### Verified scope

- GateS/GateD structure formation
- independent work-function assignment
- Low-Vd and High-Vd sweep
- initial Vtgm, SS, gm, Ion, Ioff, Ion/Ioff and DIBL

### Known limitations

- gate tunneling 미포함
- High-K 미포함
- corrected Vtgm 및 constant-current threshold 미포함
- historical baseline이므로 최종 결과 code로 사용하지 않음

---

## 6. SiO₂ gate-leakage code set

### Purpose

약 1.6 nm SiO₂ DMG 구조에서 GateS와 GateD의 tunneling current를 별도로 추출합니다.

### Files

- [`sprocess.cmd`](../source/verified/sio2_ig_baseline/sprocess.cmd)
- [`sdevice.cmd`](../source/verified/sio2_ig_baseline/sdevice.cmd)
- [`svisual.tcl`](../source/verified/sio2_ig_baseline/svisual.tcl)
- [`sdevice.par`](../source/verified/sio2_ig_baseline/sdevice.par)

### Execution order

```text
Register Workbench variables and sdevice.par
→ run SProcess
→ inspect gate-cap-removed and final TDR
→ run SDevice Low/High-Vd
→ run SVisual Id and gate-terminal extraction
```

### Expected outputs

- Vtgm
- SS
- Ion
- Ioff
- Ion/Ioff
- DIBL
- IgS
- IgD
- IgTotal

### Related result

- [`sio2_gate_leakage.csv`](../results/sio2_gate_leakage.csv)
- [Gate-leakage section](../study/index.html#8-추가-문제-발견-thin-sio₂-gate-leakage)

### Known limitations

- tunneling parameter는 절대 calibration용이 아님
- interface trap, process damage와 full band-offset calibration 미포함

---

## 7. High-K and gate-ratio verified code set

### Purpose

동일 EOT의 SiO₂ IL/HfO₂ stack, GateS/GateD ratio parameterization, gate tunneling과 개선된 DIBL extraction을 하나의 representative code set에서 수행합니다.

### Files

- [`sprocess.cmd`](../source/verified/highk_eot1p6_gate_ratio/sprocess.cmd)
- [`sdevice.cmd`](../source/verified/highk_eot1p6_gate_ratio/sdevice.cmd)
- [`svisual.tcl`](../source/verified/highk_eot1p6_gate_ratio/svisual.tcl)
- [`sdevice.par`](../source/verified/highk_eot1p6_gate_ratio/sdevice.par)

### Main features

- SiO₂ IL 0.5 nm
- HfO₂ 5.64 nm
- EOT ≈ 1.6 nm
- normalized `DMG_RatioS`
- moving GateS/GateD contact position
- GateS/GateD NonLocal tunneling
- corrected Vtgm with `−Vd/2`
- CC1 and CC2 constant-current threshold
- threshold crossing valid flag
- signed and absolute DIBL

### Expected outputs

- standard Id metrics
- IgS, IgD, IgTotal
- corrected Vtgm
- CC1/CC2 threshold
- CC-DIBL and validity information
- Workbench DOE scalars

### Related results

- [`high_k_comparison.csv`](../results/high_k_comparison.csv)
- [`gate_ratio_tradeoff.csv`](../results/gate_ratio_tradeoff.csv)
- [High-K section](../study/index.html#9-high-k-gate-stack-적용)
- [Gate-ratio section](../study/index.html#10-gatesgated-길이-비율-실험)

### Known limitations

- 2D planar concept model
- High-K absolute leakage calibration 미완료
- GAA·CFET 3D geometry 미포함
- process variability와 quantum confinement 미포함

---

## 8. Variable-EOT extension

### Purpose

`EOT_Target`에서 HfO₂ physical thickness를 계산해 1.6, 1.2, 1.0 nm 등의 후속 sweep을 가능하게 합니다.

### Files

- [`sprocess.cmd`](../source/extended/highk_eot_sweep/sprocess.cmd)
- [`sdevice.par`](../source/extended/highk_eot_sweep/sdevice.par)
- [verified SDevice](../source/verified/highk_eot1p6_gate_ratio/sdevice.cmd)
- [verified SVisual](../source/verified/highk_eot1p6_gate_ratio/svisual.tcl)

SDevice와 SVisual logic이 fixed-EOT study와 동일하므로 중복 파일 대신 verified source를 재사용합니다.

### Scope

이 확장은 성공한 후속 연구 자산이지만, 최종 학회 발표의 중심 결과는 EOT ≈ 1.6 nm 조건입니다.

---

## 9. Results files

| File | Content |
|---|---|
| [`scaling_baseline.csv`](../results/scaling_baseline.csv) | 세 gate length의 Single–Dual baseline |
| [`scaling_selected_conditions.csv`](../results/scaling_selected_conditions.csv) | scale별 parameter-screening selected conditions |
| [`sio2_gate_leakage.csv`](../results/sio2_gate_leakage.csv) | leakage-follow-up Id/Ig data |
| [`high_k_comparison.csv`](../results/high_k_comparison.csv) | same-EOT SiO₂–High-K comparison |
| [`gate_ratio_tradeoff.csv`](../results/gate_ratio_tradeoff.csv) | GateS/GateD ratio raw comparison |

각 데이터의 단계와 혼합 금지 원칙은 [Data Lineage](./data_lineage_and_reliability.html)에 기록했습니다.

---

## 10. Actual visual evidence

포트폴리오에는 직접 재구성한 schematic뿐 아니라 실제 simulation output을 공개합니다.

### Process

- [`dmg_sprocess_montage_lg_0p25.png`](../figures/actual/process/dmg_sprocess_montage_lg_0p25.png)

### Scaling

- Lg = 0.25 μm structure and transfer curve
- Lg = 0.10 μm structure and transfer curve
- Lg = 0.028 μm structure and transfer curve

[전체 연구 페이지에서 실제 이미지 보기](../study/index.html#4-lg--025-μm-1차-검증과-parameter-screening)

---

## 11. Reproducibility boundary

공개 code는 프로젝트에서 사용한 대표 command 전문이지만, 동일 수치의 완전한 재현은 다음 요소에 영향을 받을 수 있습니다.

- Sentaurus version
- material database
- license option
- Workbench node dependency
- parameter registration
- mesh
- server numerical environment
- input and output naming convention

따라서 이 저장소는 다음을 재현 가능하게 하는 데 초점을 둡니다.

1. 연구 구현 논리
2. code structure
3. process sequence
4. metric extraction method
5. selected data provenance
6. known limitations

---

## 12. AI assistance disclosure

OpenAI ChatGPT는 command 초안·수정, debugging 방향, metric-extraction logic, EOT 계산, 데이터 비교와 문서 구조화를 보조했습니다.

생성된 code나 설명을 그대로 결과로 간주하지 않았으며, Sentaurus Workbench에서 직접 실행한 log, TDR, curve와 DOE output을 기준으로 성공 여부와 최종 해석을 판단했습니다.
