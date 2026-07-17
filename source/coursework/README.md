# Initial Coursework Code

반도체집적공정 기말 프로젝트 단계에서 작성한 최초 DMG implementation입니다.

- [`sprocess_lg0p1_initial.cmd`](./sprocess_lg0p1_initial.cmd): GateS/GateD 구조, DMG gap, temporary cap, implant, contact
- [`sdevice_initial.cmd`](./sdevice_initial.cmd): independent work functions and Low/High-Vd sweep
- [`svisual_initial.tcl`](./svisual_initial.tcl): Vtgm, SS, gm, Ion, Ioff, Ion/Ioff, initial DIBL extraction

이 코드는 연구의 출발점을 보존하기 위한 historical baseline입니다. Gate tunneling, High-K, corrected Vtgm과 constant-current DIBL은 verified code set에서 확인할 수 있습니다.
