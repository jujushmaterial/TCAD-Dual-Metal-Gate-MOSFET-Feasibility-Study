(() => {
  const style = document.createElement('style');
  style.textContent = `
    .project-hero {
      padding: 58px 20px 46px;
    }

    .project-hero__inner {
      width: min(1100px, 94vw);
    }

    .project-hero h1 {
      max-width: 1080px;
      margin-left: auto;
      margin-right: auto;
      font-size: clamp(2rem, 3.6vw, 3.35rem);
      line-height: 1.18;
      letter-spacing: -0.03em;
      text-wrap: balance;
    }

    .project-hero h1 br {
      display: none;
    }

    .hero-summary {
      max-width: 930px;
      margin-top: 20px;
    }

    .project-layout {
      width: min(1320px, 96vw);
      grid-template-columns: 160px minmax(0, 1040px);
      gap: 40px;
    }

    .toc {
      padding: 16px 0;
    }

    .toc a {
      padding: 4px 0;
      font-size: 0.86rem;
    }

    .project-article {
      font-size: 17px;
    }

    .project-article p {
      line-height: 1.8;
    }

    .project-article h2 {
      font-size: 2.05rem;
    }

    .window-dots {
      display: none !important;
    }

    .code-titlebar {
      justify-content: flex-start;
      padding-left: 17px;
    }

    .editor-shell {
      grid-template-columns: 58px minmax(0, 1fr) 120px;
    }

    .code-lines {
      overflow: hidden !important;
      scrollbar-width: none;
    }

    .code-lines::-webkit-scrollbar {
      display: none;
    }

    .code-content {
      overflow: auto !important;
      min-width: 0;
      scrollbar-color: #858585 #1e1e1e;
      scrollbar-width: auto;
    }

    .code-minimap {
      position: relative;
      padding: 0 !important;
      overflow: hidden;
      cursor: pointer;
      user-select: none;
      touch-action: none;
      background: #1b1b1b;
    }

    .minimap-lines {
      position: absolute;
      inset: 10px 8px;
      overflow: hidden;
    }

    .mini-line {
      position: absolute;
      left: 0;
      height: 1px;
      margin: 0 !important;
      background: #78828d;
      opacity: 0.58;
      pointer-events: none;
    }

    .mini-line--comment {
      background: #6a9955;
      opacity: 0.72;
    }

    .mini-line--command {
      background: #4ec9b0;
      opacity: 0.7;
    }

    .minimap-viewport {
      position: absolute;
      left: 2px;
      right: 2px;
      min-height: 28px;
      border: 1px solid rgba(180, 190, 200, 0.72);
      background: rgba(130, 145, 160, 0.16);
      pointer-events: auto;
      cursor: grab;
    }

    .minimap-viewport:active {
      cursor: grabbing;
    }

    .code-toolbar .line-jump-button {
      min-width: 54px;
    }

    .code-loading {
      color: #9da5ad;
    }

    @media (max-width: 1080px) {
      .project-layout {
        width: min(1000px, 94vw);
        grid-template-columns: 1fr;
      }

      .toc {
        position: static;
        display: flex;
        flex-wrap: wrap;
        gap: 5px 14px;
        margin-bottom: 32px;
        padding: 15px 0;
      }

      .toc p {
        width: 100%;
      }

      .toc a {
        padding: 2px 0;
      }
    }

    @media (max-width: 900px) {
      .editor-shell {
        grid-template-columns: 48px minmax(0, 1fr);
      }

      .code-minimap {
        display: none;
      }
    }

    @media (max-width: 620px) {
      .project-hero h1 {
        font-size: clamp(1.85rem, 9vw, 2.45rem);
      }

      .project-article {
        font-size: 16px;
      }
    }
  `;
  document.head.appendChild(style);

  document.querySelector('.window-dots')?.remove();

  const modal = document.getElementById('code-modal');
  const codeElement = document.getElementById('code-content');
  const codeScroll = codeElement?.parentElement;
  const codeLines = document.getElementById('code-lines');
  const fileName = document.getElementById('code-file-name');
  const githubCode = document.getElementById('github-code');
  const minimap = document.getElementById('code-minimap');
  const copyButton = document.getElementById('copy-code');
  const tabs = [...document.querySelectorAll('[data-code-tab]')];

  if (!modal || !codeElement || !codeScroll || !codeLines || !fileName || !githubCode || !minimap) {
    return;
  }

  const repositoryRoot = 'https://raw.githubusercontent.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/main/source/coursework/';

  const files = {
    sprocess: {
      name: 'sprocess_lg0p1_initial.cmd',
      raw: `${repositoryRoot}sprocess_lg0p1_initial.cmd`,
      github: 'https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/coursework/sprocess_lg0p1_initial.cmd',
      code: null,
    },
    sdevice: {
      name: 'sdevice_initial.cmd',
      raw: `${repositoryRoot}sdevice_initial.cmd`,
      github: 'https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/coursework/sdevice_initial.cmd',
      code: null,
    },
    svisual: {
      name: 'svisual_initial.tcl',
      raw: `${repositoryRoot}svisual_initial.tcl`,
      github: 'https://github.com/jujushmaterial/TCAD-Dual-Metal-Gate-MOSFET-Feasibility-Study/blob/main/source/coursework/svisual_initial.tcl',
      code: null,
    },
  };

  const keywordTokens = new Set([
    'set', 'proc', 'foreach', 'for', 'if', 'elseif', 'else', 'return', 'puts',
    'lappend', 'incr', 'File', 'Electrode', 'Physics', 'Mobility', 'Recombination',
    'Math', 'Solve', 'Coupled', 'Quasistationary', 'Goal', 'Plot', 'Current',
    'Output', 'EffectiveIntrinsicDensity', 'SRH', 'NewCurrentPrefix', 'DoZero',
  ]);

  const commandTokens = new Set([
    'deposit', 'etch', 'mask', 'implant', 'diffuse', 'struct', 'contact', 'region',
    'init', 'line', 'pdbSet', 'layers', 'get_variable_data', 'format', 'expr', 'abs',
    'llength', 'lindex', 'create_plot', 'select_plots', 'set_plot_prop', 'set_axis_prop',
    'set_legend_prop', 'load_file', 'create_curve', 'set_curve_prop', 'ft_scalar',
  ]);

  const propertyTokens = new Set([
    'material', 'type', 'thickness', 'location', 'spacing', 'name', 'left', 'right',
    'dose', 'energy', 'temperature', 'Voltage', 'Workfunction', 'InitialStep',
    'Increment', 'MinStep', 'MaxStep', 'Iterations', 'concentration', 'field',
    'slice', 'angle', 'segments', 'point', 'replace', 'bottom', 'Grid',
  ]);

  const escapeHtml = (value) => value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;');

  const tokenPattern = /"[^"\n]*"|@[A-Za-z0-9_|]+@|\$[A-Za-z_][A-Za-z0-9_]*|\b(?:0x[0-9A-Fa-f]+|\d+(?:\.\d+)?(?:e[+-]?\d+)?)\b|\b[A-Za-z_][A-Za-z0-9_]*\b/g;

  const findCommentIndex = (line) => {
    let quoted = false;
    for (let index = 0; index < line.length; index += 1) {
      if (line[index] === '"' && line[index - 1] !== '\\') quoted = !quoted;
      if (line[index] === '#' && !quoted) return index;
    }
    return -1;
  };

  const tokenClass = (token) => {
    if (token.startsWith('"')) return 'tok-string';
    if (token.startsWith('@') || token.startsWith('$')) return 'tok-variable';
    if (/^(?:0x[0-9A-Fa-f]+|\d)/.test(token)) return 'tok-number';
    if (keywordTokens.has(token)) return 'tok-keyword';
    if (commandTokens.has(token)) return 'tok-command';
    if (propertyTokens.has(token)) return 'tok-property';
    return '';
  };

  const highlightCodePart = (line) => {
    let output = '';
    let lastIndex = 0;

    for (const match of line.matchAll(tokenPattern)) {
      const index = match.index ?? 0;
      const token = match[0];
      output += escapeHtml(line.slice(lastIndex, index));
      const className = tokenClass(token);
      output += className
        ? `<span class="${className}">${escapeHtml(token)}</span>`
        : escapeHtml(token);
      lastIndex = index + token.length;
    }

    output += escapeHtml(line.slice(lastIndex));
    return output;
  };

  const highlightLine = (line) => {
    const commentIndex = findCommentIndex(line);
    if (commentIndex < 0) return highlightCodePart(line);

    const codePart = line.slice(0, commentIndex);
    const commentPart = line.slice(commentIndex);
    return `${highlightCodePart(codePart)}<span class="tok-comment">${escapeHtml(commentPart)}</span>`;
  };

  const highlight = (code) => code.split('\n').map(highlightLine).join('\n');

  let currentKey = 'sprocess';
  let minimapViewport = null;
  let minimapLines = null;
  let draggingMinimap = false;
  let dragOffset = 0;

  const minimapLineClass = (line) => {
    const trimmed = line.trim();
    if (trimmed.startsWith('#')) return 'mini-line mini-line--comment';
    if (/^(deposit|etch|mask|implant|diffuse|struct|contact|region|init|line|create_|load_file|set_curve_prop)/.test(trimmed)) {
      return 'mini-line mini-line--command';
    }
    return 'mini-line';
  };

  const renderMinimap = (code) => {
    const lines = code.split('\n');
    minimap.innerHTML = '<div class="minimap-lines"></div><div class="minimap-viewport" role="scrollbar" aria-label="Code position" aria-orientation="vertical"></div>';
    minimapLines = minimap.querySelector('.minimap-lines');
    minimapViewport = minimap.querySelector('.minimap-viewport');

    minimapLines.innerHTML = lines.map((line, index) => {
      const width = Math.max(8, Math.min(96, line.trim().length * 1.6));
      const top = lines.length > 1 ? (index / (lines.length - 1)) * 100 : 0;
      return `<span class="${minimapLineClass(line)}" style="top:${top}%;width:${width}%"></span>`;
    }).join('');

    minimap.title = 'Click or drag to move through the full source file';
    requestAnimationFrame(syncMinimap);
  };

  const syncMinimap = () => {
    if (!minimapViewport) return;

    const minimapHeight = minimap.clientHeight;
    const scrollHeight = codeScroll.scrollHeight;
    const clientHeight = codeScroll.clientHeight;
    const maxScroll = Math.max(0, scrollHeight - clientHeight);
    const viewportHeight = maxScroll === 0
      ? minimapHeight
      : Math.max(28, minimapHeight * (clientHeight / scrollHeight));
    const maxTop = Math.max(0, minimapHeight - viewportHeight);
    const scrollRatio = maxScroll === 0 ? 0 : codeScroll.scrollTop / maxScroll;

    minimapViewport.style.height = `${viewportHeight}px`;
    minimapViewport.style.top = `${maxTop * scrollRatio}px`;
    minimapViewport.setAttribute('aria-valuemin', '1');
    minimapViewport.setAttribute('aria-valuemax', String(Math.max(1, codeElement.textContent.split('\n').length)));

    const lineHeight = parseFloat(getComputedStyle(codeScroll).lineHeight) || 23;
    const currentLine = Math.max(1, Math.round(codeScroll.scrollTop / lineHeight) + 1);
    minimapViewport.setAttribute('aria-valuenow', String(currentLine));
  };

  const scrollFromMinimap = (clientY, offset = 0) => {
    if (!minimapViewport) return;

    const rect = minimap.getBoundingClientRect();
    const viewportHeight = minimapViewport.offsetHeight;
    const maxTop = Math.max(0, rect.height - viewportHeight);
    const localTop = Math.max(0, Math.min(maxTop, clientY - rect.top - offset));
    const ratio = maxTop === 0 ? 0 : localTop / maxTop;
    const maxScroll = Math.max(0, codeScroll.scrollHeight - codeScroll.clientHeight);

    codeScroll.scrollTop = ratio * maxScroll;
  };

  minimap.addEventListener('pointerdown', (event) => {
    if (!minimapViewport) return;
    event.preventDefault();

    const viewportRect = minimapViewport.getBoundingClientRect();
    const isViewport = event.clientY >= viewportRect.top && event.clientY <= viewportRect.bottom;
    dragOffset = isViewport ? event.clientY - viewportRect.top : minimapViewport.offsetHeight / 2;
    draggingMinimap = true;
    minimap.setPointerCapture?.(event.pointerId);
    scrollFromMinimap(event.clientY, dragOffset);
  });

  minimap.addEventListener('pointermove', (event) => {
    if (!draggingMinimap) return;
    event.preventDefault();
    scrollFromMinimap(event.clientY, dragOffset);
  });

  const stopMinimapDrag = (event) => {
    draggingMinimap = false;
    if (event?.pointerId !== undefined) minimap.releasePointerCapture?.(event.pointerId);
  };

  minimap.addEventListener('pointerup', stopMinimapDrag);
  minimap.addEventListener('pointercancel', stopMinimapDrag);

  codeScroll.addEventListener('scroll', () => {
    codeLines.scrollTop = codeScroll.scrollTop;
    syncMinimap();
  });

  const renderCode = (code) => {
    codeElement.innerHTML = highlight(code);
    const count = code.split('\n').length;
    codeLines.textContent = Array.from({ length: count }, (_, index) => index + 1).join('\n');
    codeScroll.scrollTop = 0;
    codeScroll.scrollLeft = 0;
    codeLines.scrollTop = 0;
    renderMinimap(code);
  };

  const loadFile = async (file) => {
    if (file.code !== null) return file.code;

    const response = await fetch(file.raw, { cache: 'no-cache' });
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    file.code = await response.text();
    return file.code;
  };

  const showFile = async (key) => {
    currentKey = files[key] ? key : 'sprocess';
    const file = files[currentKey];

    tabs.forEach((tab) => tab.classList.toggle('is-active', tab.dataset.codeTab === currentKey));
    fileName.textContent = file.name;
    githubCode.href = file.github;
    codeElement.innerHTML = '<span class="code-loading">Loading full source file…</span>';
    codeLines.textContent = '';
    minimap.innerHTML = '';

    try {
      const code = await loadFile(file);
      if (currentKey !== key && files[key]) return;
      renderCode(code);
    } catch (error) {
      codeElement.textContent = `전체 코드를 불러오지 못했습니다. GitHub 버튼으로 원본 파일을 확인해 주세요.\n\n${error.message}`;
      codeLines.textContent = '';
      minimap.innerHTML = '';
    }
  };

  const goToLine = () => {
    const activeFile = files[currentKey];
    const lineCount = activeFile.code ? activeFile.code.split('\n').length : 1;
    const answer = window.prompt(`이동할 줄 번호를 입력하세요. (1–${lineCount})`, '1');
    if (answer === null) return;

    const requested = Number.parseInt(answer, 10);
    if (!Number.isFinite(requested)) return;

    const line = Math.max(1, Math.min(lineCount, requested));
    const lineHeight = parseFloat(getComputedStyle(codeScroll).lineHeight) || 23;
    codeScroll.scrollTop = (line - 1) * lineHeight;
    codeScroll.focus();
  };

  const toolbarActions = copyButton?.parentElement;
  if (toolbarActions) {
    const lineButton = document.createElement('button');
    lineButton.type = 'button';
    lineButton.className = 'line-jump-button';
    lineButton.textContent = 'Line';
    lineButton.title = 'Go to line (Ctrl+G)';
    lineButton.addEventListener('click', goToLine);
    toolbarActions.prepend(lineButton);
  }

  const openModal = (key = 'sprocess') => {
    modal.classList.add('is-open');
    modal.setAttribute('aria-hidden', 'false');
    document.body.classList.add('modal-open');
    showFile(key);
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

  tabs.forEach((tab) => {
    tab.addEventListener('click', () => showFile(tab.dataset.codeTab));
  });

  copyButton?.addEventListener('click', async () => {
    const file = files[currentKey];

    try {
      const code = await loadFile(file);
      await navigator.clipboard.writeText(code);
      const original = copyButton.textContent;
      copyButton.textContent = 'Copied';
      setTimeout(() => { copyButton.textContent = original; }, 1200);
    } catch {
      copyButton.textContent = 'Copy failed';
      setTimeout(() => { copyButton.textContent = 'Copy'; }, 1200);
    }
  });

  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && modal.classList.contains('is-open')) {
      closeModal();
      return;
    }

    if (modal.classList.contains('is-open') && event.ctrlKey && event.key.toLowerCase() === 'g') {
      event.preventDefault();
      goToLine();
    }
  });

  window.addEventListener('resize', syncMinimap);
})();
