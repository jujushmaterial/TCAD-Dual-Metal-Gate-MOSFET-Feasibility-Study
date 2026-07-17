(() => {
  const content = document.querySelector('.document-content');
  if (!content) return;

  const redundantLabels = [
    '프로젝트 첫 페이지',
    '발표 흐름으로 정리한 전체 연구',
    '발표 흐름으로 읽는 전체 연구',
    '← 전체 연구'
  ];

  const isRedundant = (text) => redundantLabels.some((label) => text.trim() === label);

  [...content.querySelectorAll('a')].forEach((link) => {
    if (!isRedundant(link.textContent || '')) return;
    const item = link.closest('li');
    if (item) {
      const list = item.parentElement;
      item.remove();
      if (list && !list.querySelector('li')) list.remove();
      return;
    }

    const parent = link.parentElement;
    link.remove();
    if (parent && !parent.textContent.trim() && !parent.querySelector('*')) parent.remove();
  });

  [...content.querySelectorAll('p')].forEach((paragraph) => {
    const text = paragraph.textContent.replace(/[·|]/g, '').trim();
    if (!text) paragraph.remove();
  });
})();
