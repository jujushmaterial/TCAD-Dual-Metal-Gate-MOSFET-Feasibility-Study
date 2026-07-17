---
layout: default
title: Final Conference Presentation
---

# Final Conference Presentation

**Dual-Metal Gate를 이용한 미세 MOSFET의 SCE 및 Leakage Current 개선 효과 분석**

| Item | Description |
|---|---|
| Event | 숭실대학교 차세대반도체학과 특별세션 |
| Presenters | 이선재, 주상현 |
| Slides | 26 |
| Study | Dual-Metal-Gate MOSFET Feasibility Study |
| Tool | Synopsys Sentaurus T-2022.03 |

<div class="nav-links">
<a href="./final_conference_presentation.pdf">View Final Presentation PDF</a>
<a href="./final_conference_presentation.pptx">Download Original PPTX</a>
<a href="../study/index.html">Read the Full Study</a>
<a href="../index.html">Project Page</a>
</div>

## Presentation flow

1. Work-Function Engineering의 필요성
2. GAA·CFET와 dual-WFM 선행연구
3. 2D planar MOSFET test vehicle을 이용한 연구 방향 설정
4. 미세 MOSFET의 SCE·DIBL·Ioff 문제
5. Source-side low-WF / drain-side high-WF DMG 가설
6. DIBL 정의와 TCAD 평가 방법
7. SProcess 기반 GateS/GateD 구현
8. Lg = 0.25 μm 검증 및 parameter screening
9. Lg = 0.10 μm 재검증 및 parameter screening
10. Lg = 0.028 μm 미세화 적용성 검증
11. DIBL 특이값과 extraction 신뢰성 고찰
12. Thin-SiO₂ gate leakage 문제 발견
13. 동일 EOT의 SiO₂ IL/HfO₂ High-K 적용
14. GateS/GateD 길이 비율 trade-off
15. 결론, 한계와 GAA·CFET 확장 방향

## Files

- [Final conference presentation — PDF](./final_conference_presentation.pdf)
- [Final conference presentation — PPTX](./final_conference_presentation.pptx)
- [Text outline](./conference_presentation_outline.html)

PDF는 브라우저에서 발표자료 전체를 확인하기 위한 파일이며, PPTX는 원본 발표자료 보존 및 다운로드용입니다.

## Portfolio policy

이 발표자료의 연구 흐름과 결론을 포트폴리오의 primary narrative로 사용합니다.

- PPT에 제시한 scaling·optimization·leakage·High-K·ratio 순서를 보존합니다.
- 발표 이후 추가한 corrected Vtgm과 constant-current validation은 별도 후속 검증으로 표시합니다.
- 발표 15장의 scaling-stage 0.028 μm 값과 발표 17장의 leakage-follow-up 값을 같은 unchanged condition으로 합치지 않습니다.
- 5:5 ratio는 절대 최적점이 아니라 balanced reference로 설명합니다.

## AI assistance disclosure

OpenAI ChatGPT는 TCAD command 초안·수정, 데이터 비교, 발표 구조화와 일부 발표용 도식 제작을 보조했습니다. 모든 simulation result는 연구 참여자가 Sentaurus Workbench에서 직접 실행하고 구조, curve, DOE output을 확인해 사용했습니다.
