---
layout: default
title: TCAD Dual-Metal-Gate MOSFET Feasibility Study
---

# Dual-Metal Gate를 이용한 미세 MOSFET의 SCE 및 Leakage Current 개선 효과 분석

2D planar MOSFET에서 source–drain 방향의 Work-Function Split을 구현하고, scaling, 공정조건 screening, gate leakage, High-K gate stack, GateS/GateD 비율 변화에 따른 trade-off를 검토한 Sentaurus TCAD 연구입니다.

**Summary:**  
This conference-presented study examines lateral work-function splitting in a 2D Sentaurus TCAD test vehicle and follows the full research process from scaling and parameter screening to gate-leakage mitigation and gate-ratio analysis.

| Item | Description |
|---|---|
| Period | 2026.03–2026.07 |
| Status | Conference Presented |
| Tool | Synopsys Sentaurus TCAD T-2022.03 |
| Modules | Sentaurus Workbench, SProcess, SDevice, SVisual |
| Device | 2D planar nMOS test vehicle |
| Main variables | Gate length, process parameters, GateS/GateD work function and length ratio |
| Metrics | DIBL, SS, Ion, Ioff, Ion/Ioff, gate current |

- [발표 흐름으로 전체 연구 읽기](./study/)
- [최종 발표자료 PDF 보기](./presentation/final_conference_presentation.pdf)
- [원본 PPTX 다운로드](./presentation/final_conference_presentation.pptx)
- [전체 TCAD 코드](./source/)
- [결과 데이터](./results/)
- [참고문헌](./references/)

---

## 연구 질문

미세화된 MOSFET에서 source 측에는 낮은 work function, drain 측에는 높은 work function을 적용하면 다음 역할을 분리할 수 있는지 확인했습니다.

| Gate region | Work function | Intended role |
|---|---:|---|
| GateS, source side | 4.2 eV | carrier injection을 유지해 Ion 손실 제한 |
| GateD, drain side | 4.8 eV | drain field penetration과 barrier lowering 억제 |

![최종 발표에서 사용한 Single-Metal Gate와 Dual-Metal Gate 비교](./figures/presentation/slide_09_dmg_solution.png)

초기 가설은 Ion을 유지하거나 소폭 감소시키면서 Ioff와 DIBL을 낮추고, 결과적으로 Ion/Ioff를 높일 수 있다는 것이었습니다.

---

## 연구 진행 흐름

1. Work-Function Engineering과 Dual-Metal Gate 선행연구 검토
2. SimpleMOS 기반 GateS/GateD SProcess 구현
3. Lg = 0.25, 0.10, 0.028 μm에서 DMG 효과 반복 검증
4. NWell, LDD, Source/Drain 조건 screening 및 representative condition 선정
5. DIBL 추출 특이값과 신뢰성 문제 검토
6. Thin-SiO₂ gate leakage 문제 발견
7. 동일 EOT의 SiO₂ interfacial layer/HfO₂ stack 적용
8. GateS/GateD 길이 비율에 따른 trade-off 분석
9. 실제 GAA·CFET 적용을 위한 한계와 후속 연구 정리

[최종 발표 순서로 전체 과정 보기](./study/)

---

## TCAD 공정 구현

SProcess에서 GateS와 GateD를 서로 다른 material region으로 형성하고, 두 gate 사이에 작은 `DMG_Gap`을 두었습니다. Implant 중 gap을 통한 dopant 침투를 줄이기 위해 temporary nitride cap을 적용한 뒤, Source/Drain implant와 anneal 후 제거했습니다.

![실제 SProcess checkpoint를 연결한 공정 흐름](./figures/actual/process/dmg_sprocess_montage_lg_0p25.png)

SDevice에서는 두 gate에 독립적인 work function을 지정하고 같은 gate voltage로 동시에 sweep했습니다. SVisual에서는 Vth, SS, gm, Ion, Ioff, Ion/Ioff와 DIBL을 자동 추출했습니다.

[실제 코드와 실행 구조 보기](./source/)

---

## 세 gate length의 검증과 조건 선정

각 scale에서 NWell, LDD dose/energy, Source/Drain dose/energy를 screening하고, `Ion/Ioff–DIBL` 분포와 SS·Ion을 함께 비교해 representative condition을 선정했습니다.

### Lg = 0.25 μm

![Lg 0.25 μm 실제 GateS/GateD 구조](./figures/actual/scaling/lg_0p25_gate_cap_removed.png)

첫 DMG 효과를 검증하고 parameter screening 방법을 정립했습니다.

### Lg = 0.10 μm

![Lg 0.10 μm 실제 GateS/GateD 구조](./figures/actual/scaling/lg_0p10_gate_cap_removed.png)

Gate length 감소 후에도 Ion 일부 손실과 함께 Ioff 및 Ion/Ioff가 개선되는 방향을 재검증했습니다.

### Lg = 0.028 μm

![Lg 0.028 μm 실제 GateS/GateD 구조](./figures/actual/scaling/lg_0p028_gate_cap_removed.png)

구조가 붕괴하지 않는 baseline을 먼저 탐색한 뒤 미세화 적용성을 확인했습니다.

| Metric | Repeated DMG direction |
|---|---|
| Ion | 소폭 감소 |
| Ioff | 큰 폭 감소 |
| Ion/Ioff | 큰 폭 증가 |
| DIBL | 감소 방향이지만 extraction method에 민감 |
| SS | 조건에 따른 trade-off |

![세 gate length 결과와 DIBL 신뢰성 검토](./figures/presentation/slide_16_scaling_result_and_reliability.png)

이 과정은 생산 가능한 절대 최적 공정을 주장하는 작업이 아니라, 여러 scale에서 DMG의 상대적 물리 효과를 확인하기 위한 **parameter screening and comparative optimization**입니다.

[최적화 지점 선정 과정 자세히 보기](./appendix/optimization_details.html)

---

## Gate leakage 문제와 High-K 개선

Lg = 0.028 μm에서 약 1.6 nm SiO₂를 사용할 경우, drain-current 기반 Ioff가 감소하더라도 on-state gate tunneling이 남는 것을 확인했습니다.

![Thin-SiO₂ gate leakage 문제](./figures/presentation/slide_17_gate_leakage_problem.png)

EOT를 약 1.6 nm로 유지하면서 물리 두께를 늘리기 위해 SiO₂ interfacial layer/HfO₂ stack을 적용했습니다.

| Stack | EOT | Physical thickness | IgTotal On, High-Vd |
|---|---:|---:|---:|
| SiO₂ | 1.6 nm | 1.6 nm | 1.8897e-9 A/μm |
| SiO₂ IL/HfO₂ | 1.5998 nm | 6.14 nm | 1.135e-11 A/μm |

![High-K 적용 전후 gate leakage 비교](./figures/presentation/slide_19_highk_leakage_result.png)

대표 High-Vd 조건에서 `IgTotal_On`은 약 **99.40% 감소**했습니다. 이 수치는 calibrated absolute prediction이 아니라 동일 simulation framework 안에서 비교한 first-pass relative result입니다.

---

## GateS/GateD 비율 변화

총 gate region을 유지하면서 GateS:GateD를 6:4, 5:5, 4.5:5.5, 3.5:6.5로 변경했습니다.

![GateS/GateD 비율 변화 실험 설계](./figures/presentation/slide_20_gate_ratio_design.png)

Drain-side high-WF 영역이 커질수록 Ioff, gate current와 SS는 개선되는 방향을 보였지만, GateS가 짧아지면서 Ion이 소폭 감소했고 DIBL은 비단조적으로 변했습니다.

![Gate-ratio 결과 해석](./figures/presentation/slide_23_gate_ratio_interpretation.png)

5:5는 모든 지표의 절대 최적점이 아니라, Ion 손실과 drain-side suppression을 함께 고려한 **balanced reference condition**입니다. 4.5:5.5에서 추출된 매우 낮은 DIBL은 low-confidence data로 분류했습니다.

---

## 핵심 결론

1. Source-side low WF와 drain-side high WF의 역할 분리 가능성을 확인했습니다.
2. 세 gate length에서 DMG는 Ion 일부 손실과 함께 Ioff와 Ion/Ioff를 개선하는 방향을 반복적으로 보였습니다.
3. DIBL 특이값을 발견하고 SS, Ion, Ioff, Ion/Ioff를 함께 고려하는 신뢰성 정책을 도입했습니다.
4. Thin-SiO₂ gate leakage를 추가 문제로 확인하고 High-K stack의 완화 가능성을 검토했습니다.
5. Gate ratio는 하나의 절대 최적값이 아니라 source injection과 drain suppression을 조정하는 trade-off 변수입니다.

> **연구 범위**  
> 본 결과는 2D planar TCAD test vehicle의 상대 비교입니다. 실제 GAA·CFET의 dual-WFM deposition, etch-back, alignment, metal filling과 variability를 실증한 결과가 아닙니다.

---

## 상세 자료

- [발표 흐름으로 정리한 전체 연구](./study/)
- [세 gate length의 최적화 과정](./appendix/optimization_details.html)
- [데이터 단계와 DIBL 신뢰성](./appendix/data_lineage_and_reliability.html)
- [재현 방법과 코드 연결](./appendix/reproducibility.html)
- [최종 발표자료](./presentation/)
- [전체 TCAD 코드](./source/)
- [결과 데이터](./results/)
- [참고문헌](./references/)

## AI assistance disclosure

OpenAI ChatGPT는 TCAD command 초안·수정, debugging 방향, metric-extraction logic, 데이터 비교, 발표 및 포트폴리오 구조화를 보조했습니다. 모든 simulation result는 Sentaurus Workbench에서 직접 실행한 log, TDR, curve와 DOE output을 확인해 사용했습니다.
