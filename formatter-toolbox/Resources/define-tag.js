class InfoTag extends HTMLElement {
    constructor() {
        super();
    }

    connectedCallback() {
        let width = this.hasAttribute('width') ? Number(this.getAttribute('width')) + 'px' : 'auto';
        let height = this.hasAttribute('height') ? Number(this.getAttribute('height')) + 'px' : '27px';
        let size = this.hasAttribute('size') ? Number(this.getAttribute('size')) + 'px' : '13px';
        let type = this.getAttribute('type') || 'custom';
        let color = '#ffffff';
        let background = '#323232';
        if (this.getAttribute('type') === 'success') {
            color = '#33a000';
            background = '#ccf7cd';
        } else if (this.getAttribute('type') === 'error') {
            color = '#d80000';
            background = '#ffcaca';
        } else {
            color = this.getAttribute('color') || '#ffffff';
            background = this.getAttribute('background') || '#323232';
        }
        let svg = BUTON_INFO_DEFINE[type] ? BUTON_INFO_DEFINE[type].svg + '&nbsp;' : '';
        let id = String.fromCharCode(97 + Math.ceil(Math.random() * 25)) + md5(new Date() + width + height + size + type + color + background);

        this.innerHTML = svg;
        const style = document.createElement('style');
        style.textContent = `
            .${id} {
                width: ${width};
                height: ${height};
                padding: 0 10px;
                line-height: ${height};
                font-size: ${size};
                color: ${color};
                background: ${background};
                border-radius: 5px;
                display: ${this.hasAttribute('disappear') ? 'none' : 'flex'};
                flex-direction: row;
                align-items: center;
            }
        `;
        this.appendChild(style);
        this.classList.add(id);
    }
}

customElements.define('info-tag', InfoTag);
