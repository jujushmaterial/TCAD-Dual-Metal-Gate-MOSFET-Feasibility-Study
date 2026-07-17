---
layout: default
title: Data Lineage and DIBL Reliability
---

# Data Lineage and DIBL Reliability

[← 전체 연구](../study/index.html) · [최적화 과정](./optimization_details.html)

이 문서는 프로젝트 진행 중 생성된 데이터가 어떤 단계에서 만들어졌는지 구분하고, 초기 Vtgm 기반 DIBL의 신뢰성 문제와 발표 이후 보완 과정을 기록합니다.

---

## 1. 데이터 단계 구분

| Stage | Purpose | Main conditions | Primary source |
|---|---|---|---|
| A. Scaling baseline | 세 gate length에서 Single–Dual 기본 방향 비교 | Lg = 0.25, 0.10, 0.028 μm | `results/scaling_baseline.csv` |
| B. Scaling selected conditions | 각 scale의 parameter screening 후 대표 조건 비교 | NWell, LDD, SD 변수 screening | `results/scaling_selected_conditions.csv` |
| C. Leakage follow-up | 0.028 μm에서 GateS/GateD tunneling 추가 평가 | SiO₂ 약 1.6 nm, geometry/ratio 추가 조정 | `results/sio2_gate_leakage.csv` |
| D. High-K comparison | 동일 EOT에서 SiO₂와 SiO₂ IL/HfO₂ 비교 | EOT ≈ 1.6 nm | `results/high_k_comparison.csv` |
| E. Gate-ratio study | GateS/GateD 길이 비율에 따른 trade-off | 6:4, 5:5, 4.5:5.5, 3.5:6.5 | `results/gate_ratio_tradeoff.csv` |
| F. Post-presentation validation | DIBL extraction 신뢰성 보완 | corrected Vtgm, CC1/CC2, valid flag | verified SVisual code |

---

## 2. 가장 중요한 데이터 분리 원칙

### Scaling-stage 0.028 μm

발표 15장의 scaling 및 parameter-screening 단계입니다.

대표 selected condition:

| Gate | DIBL | SS | Ion | Ioff | Ion/Ioff |
|---|---:|---:|---:|---:|---:|
| Single | 128.67 | 79.98 | 3.34e-4 | 3.78e-12 | 8.85e7 |
| Dual | 57.58 | 83.41 | 3.16e-4 | 3.28e-17 | 9.62e12 |

### Leakage-follow-up 0.028 μm

발표 17장의 gate-leakage 추가 실험입니다. 발표자료에는 소자 비율 추가 개선으로 전체 데이터가 앞 페이지와 달라졌음을 명시합니다.

| Gate | DIBL | SS | Ion | Ioff | Ion/Ioff |
|---|---:|---:|---:|---:|---:|
| Single | 113.63 | 82.10 | 2.10e-4 | 2.22e-11 | 9.45e6 |
| Dual | 37.65 | 85.42 | 2.05e-4 | 2.90e-16 | 7.05e11 |

따라서 위 두 표는 같은 조건이 아닙니다.

> **금지되는 해석**  
> Scaling selected condition의 Id metrics와 leakage-follow-up의 Ig metrics를 하나의 동일 simulation row로 결합하지 않습니다.

---

## 3. High-K comparison의 기준

High-K 비교는 leakage-follow-up의 SiO₂ DMG 조건과, 동일한 nominal EOT를 갖는 SiO₂ IL/HfO₂ DMG 조건을 비교합니다.

| Stack | EOT | Physical thickness | DIBL | SS | Ion | Ioff | IgTotal On, High-Vd |
|---|---:|---:|---:|---:|---:|---:|---:|
| SiO₂ | 1.6 nm | 1.6 nm | 37.65 | 85.42 | 2.05e-4 | 2.90e-16 | 1.8897e-9 |
| SiO₂ IL/HfO₂ | 1.5998 nm | 6.14 nm | 22.47 | 84.85 | 1.8418e-4 | 4.2916e-16 | 1.135e-11 |

High-K의 핵심 결론은 절대 leakage 예측이 아니라 동일 framework 안에서 물리 두께 증가가 tunneling current를 낮추는 방향을 확인한 것입니다.

---

## 4. Gate-ratio data의 위치

Gate-ratio 실험은 High-K EOT ≈ 1.6 nm 구조에서 진행한 별도 study입니다.

| Ratio | DIBL | Confidence | Main interpretation |
|---|---:|---|---|
| 6:4 | 19.47 | normal diagnostic | Ion이 가장 높지만 Ioff·SS·Ig가 상대적으로 불리 |
| 5:5 | 22.35 | balanced reference | Ion 유지와 off-state metrics 사이의 균형 |
| 4.5:5.5 | 2.57 | low confidence | 비정상적으로 낮은 DIBL outlier |
| 3.5:6.5 | 56.89 | normal diagnostic | Ioff·Ig는 가장 낮지만 Ion 감소와 DIBL 악화 |

5:5는 global optimum이 아니라, 발표에서 사용한 balanced reference condition입니다.

---

## 5. 초기 Vtgm 기반 DIBL

초기 SVisual에서는 gm peak에서 linear extrapolation한 threshold를 사용했습니다.

```text
VtgmRaw = Vgm − Id(Vgm) / gmmax
```

일부 조건에서 다음 현상이 발생했습니다.

```text
Vtgm_High > Vtgm_Low
```

이는 일반적인 DIBL 방향과 반대인 signed threshold shift를 만들 수 있습니다. 이 값을 곧바로 우수한 소자 성능으로 해석하지 않고, threshold extraction definition의 민감성을 우선 검토했습니다.

---

## 6. 발표 단계의 신뢰성 정책

최종 발표에서는 다음 기준을 사용했습니다.

1. DIBL 특이값은 신뢰성이 낮은 데이터로 표시
2. 극단적인 DIBL 하나만으로 조건을 선택하지 않음
3. SS, Ion, Ioff, Ion/Ioff와 함께 판단
4. 절대값보다 scale과 ratio에 따른 반복 방향을 중심으로 결론
5. 원본 값을 삭제하지 않고 오류 가능성 고찰을 보존

이 정책은 발표 16장과 22~23장에 반영돼 있습니다.

---

## 7. 발표 이후 보완 1: corrected Vtgm

최종 verified SVisual code에서는 gm extrapolation에 drain-bias correction을 추가했습니다.

```text
VtgmCorrected = Vgm − Id(Vgm)/gmmax − Vd/2
```

이 값은 기존 발표 raw table을 소급해서 덮어쓰기 위한 것이 아니라, 동일 문제가 반복되는지 진단하기 위한 후속 metric입니다.

---

## 8. 발표 이후 보완 2: constant-current Vth

두 개의 current target을 사용했습니다.

```text
CC1 = 1e-7 A/μm
CC2 = 1e-8 A/μm
```

처리 방식:

- log-current interpolation
- target current crossing 여부 확인
- Low-Vd와 High-Vd 각각의 Vth 계산
- signed DIBL과 absolute DIBL 출력
- crossing이 없으면 valid flag로 기록

### Why two targets?

하나의 current target이 모든 subthreshold curve에 동일하게 적합하지 않을 수 있으므로, CC1과 CC2를 diagnostic pair로 사용했습니다.

---

## 9. 최종 해석 우선순위

현재 포트폴리오는 아래 순서로 데이터를 해석합니다.

1. simulation이 정상적으로 수렴하고 구조가 올바른지 확인
2. threshold crossing valid flag 확인
3. corrected Vtgm과 CC1/CC2 비교
4. DIBL이 비단조적이거나 극단적이면 low-confidence로 표시
5. SS, Ion, Ioff, Ion/Ioff, Ig와 함께 해석
6. 여러 geometry에서 반복되는 방향을 최종 결론으로 사용

---

## 10. CSV 개선 필요사항

현재 공개된 CSV는 발표 및 포트폴리오의 핵심 값을 제공하지만, 모든 행에 extraction version과 valid flag가 포함된 것은 아닙니다.

향후 권장 schema:

```text
Stage
Geometry_ID
Lg
Gate_Ratio
Stack
Vth_Method
Current_Target
Crossing_Valid_Low
Crossing_Valid_High
DIBL_Signed
DIBL_Absolute
Confidence
Source_Workbench_Node
```

현 단계에서는 기존 CSV를 변경해 과거 데이터가 새 추출값처럼 보이게 만들지 않고, 본 문서에서 provenance를 명확히 기록합니다.

---

## Related files

- [Scaling baseline CSV](../results/scaling_baseline.csv)
- [Scaling selected conditions CSV](../results/scaling_selected_conditions.csv)
- [SiO₂ gate leakage CSV](../results/sio2_gate_leakage.csv)
- [High-K comparison CSV](../results/high_k_comparison.csv)
- [Gate-ratio trade-off CSV](../results/gate_ratio_tradeoff.csv)
- [Verified SVisual source](../source/verified/highk_eot1p6_gate_ratio/svisual.tcl)
