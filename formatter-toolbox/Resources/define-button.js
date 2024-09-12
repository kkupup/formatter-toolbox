class FuncTextButton extends HTMLElement {
    constructor() {
        super();
    }

    connectedCallback() {
        let width = Number(this.getAttribute('width')) || 100;
        let height = Number(this.getAttribute('height')) || 25;
        let size = Number(this.getAttribute('size')) || 13;
        let type = this.getAttribute('type') || 'default';
        let text = this.getAttribute('text') || BUTON_INFO_DEFINE[type].text;
        let svg = BUTON_INFO_DEFINE[type].svg + '&nbsp;';
        let id = String.fromCharCode(97 + Math.ceil(Math.random() * 25)) + md5(new Date() + width + height + size + type + text);

        this.classList.add(id);
        this.innerHTML = svg;
        const span = document.createElement('SPAN');
        span.append(text);
        const style = document.createElement('style');
        style.textContent = `
            .${id} {
                width: ${width}px;
                height: ${height}px;
                color: ${this.hasAttribute('opposite') ? '#ffffff' : '#323232'};
                background: ${this.hasAttribute('opposite') ? '#323232' : '#ffffff'};
                font-family: 'Balthazar Regular';
                font-size: ${size}px;
                cursor: pointer;
                border-radius: 8px;
                border: 1px solid #323232;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.3s;
            }
            .${id} > svg {
                height: ${size}px;
            }
            .${id}:hover {
                color: ${this.hasAttribute('opposite') ? '#323232' : '#ffffff'};
                background: ${this.hasAttribute('opposite') ? '#ffffff' : '#323232'};
            }
        `;
        this.appendChild(span);
        this.appendChild(style);
    }
}

class FuncIconButton extends HTMLElement {
    constructor() {
        super();
    }

    connectedCallback() {
        let width = Number(this.getAttribute('width')) || 16;
        let height = Number(this.getAttribute('height')) || 16;
        let size = Number(this.getAttribute('size')) || 16;
        let type = this.getAttribute('type') || 'setting';
        let svg = BUTON_INFO_DEFINE[type].svg;
        let id = String.fromCharCode(97 + Math.ceil(Math.random() * 25)) + md5(new Date() + width + height + size + type);

        this.classList.add(id);
        this.innerHTML = svg;

        const style = document.createElement('style');
        style.textContent = `
            .${id} {
                width: ${width}px;
                height: ${height}px;
                color: #323232;
                background: #ffffff;
                cursor: pointer;
                transition: transform 0.3s;
            }
            .${id} > svg {
                height: ${size}px;
            }
            .${id}:hover {
                transform: rotate(360deg);
            }
        `;
        this.appendChild(style);
    }
}

BUTON_INFO_DEFINE = {
    default: {
        text: ``,
        svg: ``,
    },
    copy: {
        text: `Copy`,
        svg: `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M4 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2zm2-1a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1zM2 5a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1v-1h1v1a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h1v1z" /></svg>`,
    },
    clean: {
        text: `Clean`,
        svg: `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 1024 1024"><path d="M976.269717 503.930499l-91.323134-171.388329a93.527485 93.527485 0 0 0-83.292996-48.731914H662.149628a2.361805 2.361805 0 0 1-2.361805-2.283078V64.870916C659.787823 29.365111 629.477989 0.551088 592.318921 0.551088H484.541878c-37.237795 0-67.390175 28.89275-67.390174 64.319828V281.605905a2.361805 2.361805 0 0 1-2.361806 2.361805H275.128485c-35.348351 0-67.153994 18.579534-83.214269 48.653186L100.591082 503.930499a63.296379 63.296379 0 0 0 2.597986 64.713462 69.279619 69.279619 0 0 0 56.683324 31.490736C154.282787 715.548243 114.132099 835.44922 52.016623 919.529484a63.611286 63.611286 0 0 0-4.959791 68.728531c11.96648 22.043515 35.584531 35.741985 61.721842 35.741985h720.35058c41.882679 0 78.96302-27.003306 89.984778-65.579457 18.579534-64.556008 34.009995-123.28623 35.190897-188.472054a372.535404 372.535404 0 0 0-35.899439-169.813792 69.909433 69.909433 0 0 0 55.344968-31.490736 63.296379 63.296379 0 0 0 2.597986-64.713462z m-816.00369 29.050204l91.323133-171.467057a26.452218 26.452218 0 0 1 23.539325-13.69847h139.346506c38.339971 0 69.515799-29.680018 69.515799-66.287998V64.870916l0.314908-0.314908h107.85577l0.314907 0.314908V281.605905c0 36.60798 31.097102 66.287999 69.437072 66.287998h139.346506c9.998309 0 18.973168 5.274698 23.539325 13.69847l91.323134 171.467057c0.314907 0.314907 0.629815 1.102176-0.078727 2.283078-0.787268 1.102176-1.574537 1.102176-2.046898 1.102176H162.470378c-0.472361 0-1.338356 0-2.046898-1.102176-0.787268-1.180903-0.393634-1.968171-0.157453-2.361805z m727.042361 235.865611c-1.102176 57.706773-15.430461 112.3432-32.829092 172.647958a26.216038 26.216038 0 0 1-25.350042 18.500808H677.501362a353.011148 353.011148 0 0 0 40.386868-159.028216c-0.157454-19.602983-18.579534-34.403629-38.812332-31.333282a32.671638 32.671638 0 0 0-28.341662 31.726916c0.157454 48.81064-16.847544 112.264473-51.093719 158.634582H383.37789a380.250634 380.250634 0 0 0 65.658184-153.517337c3.306527-19.524256-12.517567-37.159068-33.065273-37.159068a33.065273 33.065273 0 0 0-33.065273 26.609671 313.805182 313.805182 0 0 1-21.256246 69.043438c-12.045206 28.026755-33.222726 66.366726-66.524179 95.180749H108.778674c-0.551088 0-1.417083 0-2.125625-1.259629-0.787268-1.259629-0.236181-1.889444 0.078727-2.361805 35.584531-48.023372 65.658184-107.934497 86.835704-172.962867 19.366802-59.517491 30.782194-122.184055 33.537633-183.197355h616.273699c30.703467 53.06189 45.110479 108.328131 43.929576 168.475437z" p-id="1473" ></path></svg>`,
    },
    import: {
        text: `Import`,
        svg: `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16"><path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z" /><path d="M7.646 1.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 2.707V11.5a.5.5 0 0 1-1 0V2.707L5.354 4.854a.5.5 0 1 1-.708-.708l3-3z" /></svg>`,
    },
    export: {
        text: `Export`,
        svg: `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16"><path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z" /><path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z" /></svg>`,
    },
    format: {
        text: `Format`,
        svg: `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16"><path d="M10.478 1.647a.5.5 0 1 0-.956-.294l-4 13a.5.5 0 0 0 .956.294l4-13zM4.854 4.146a.5.5 0 0 1 0 .708L1.707 8l3.147 3.146a.5.5 0 0 1-.708.708l-3.5-3.5a.5.5 0 0 1 0-.708l3.5-3.5a.5.5 0 0 1 .708 0zm6.292 0a.5.5 0 0 0 0 .708L14.293 8l-3.147 3.146a.5.5 0 0 0 .708.708l3.5-3.5a.5.5 0 0 0 0-.708l-3.5-3.5a.5.5 0 0 0-.708 0z" /></svg>`,
    },
    setting: {
        text: `Setting`,
        svg: `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16""><path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z" /><path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 0 1-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 0 1-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 0 1 .52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 0 1 1.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 0 1 1.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 0 1 .52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 0 1-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 0 1-1.255-.52l-.094-.319zm-2.633.283c.246-.835 1.428-.835 1.674 0l.094.319a1.873 1.873 0 0 0 2.693 1.115l.291-.16c.764-.415 1.6.42 1.184 1.185l-.159.292a1.873 1.873 0 0 0 1.116 2.692l.318.094c.835.246.835 1.428 0 1.674l-.319.094a1.873 1.873 0 0 0-1.115 2.693l.16.291c.415.764-.42 1.6-1.185 1.184l-.291-.159a1.873 1.873 0 0 0-2.693 1.116l-.094.318c-.246.835-1.428.835-1.674 0l-.094-.319a1.873 1.873 0 0 0-2.692-1.115l-.292.16c-.764.415-1.6-.42-1.184-1.185l.159-.291A1.873 1.873 0 0 0 1.945 8.93l-.319-.094c-.835-.246-.835-1.428 0-1.674l.319-.094A1.873 1.873 0 0 0 3.06 4.377l-.16-.292c-.415-.764.42-1.6 1.185-1.184l.292.159a1.873 1.873 0 0 0 2.692-1.115l.094-.319z" />`,
    },
    history: {
        text: `History`,
        svg: `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16"><path d="M8.515 1.019A7 7 0 0 0 8 1V0a8 8 0 0 1 .589.022zm2.004.45a7 7 0 0 0-.985-.299l.219-.976q.576.129 1.126.342zm1.37.71a7 7 0 0 0-.439-.27l.493-.87a8 8 0 0 1 .979.654l-.615.789a7 7 0 0 0-.418-.302zm1.834 1.79a7 7 0 0 0-.653-.796l.724-.69q.406.429.747.91zm.744 1.352a7 7 0 0 0-.214-.468l.893-.45a8 8 0 0 1 .45 1.088l-.95.313a7 7 0 0 0-.179-.483m.53 2.507a7 7 0 0 0-.1-1.025l.985-.17q.1.58.116 1.17zm-.131 1.538q.05-.254.081-.51l.993.123a8 8 0 0 1-.23 1.155l-.964-.267q.069-.247.12-.501m-.952 2.379q.276-.436.486-.908l.914.405q-.24.54-.555 1.038zm-.964 1.205q.183-.183.35-.378l.758.653a8 8 0 0 1-.401.432z" /><path d="M8 1a7 7 0 1 0 4.95 11.95l.707.707A8.001 8.001 0 1 1 8 0z" /><path d="M7.5 3a.5.5 0 0 1 .5.5v5.21l3.248 1.856a.5.5 0 0 1-.496.868l-3.5-2A.5.5 0 0 1 7 9V3.5a.5.5 0 0 1 .5-.5" /></svg>`,
    },
    success: {
        text: `Success`,
        svg: `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16"><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z" /><path d="M10.97 4.97a.235.235 0 0 0-.02.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-1.071-1.05z" /></svg>`,
    },
    error: {
        text: `Error`,
        svg: ` <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16"><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z" /><path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z" /></svg>`,
    },
    clear: {
        text: `Clear All`,
        svg: `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16"><path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z" /><path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z" /></svg>`,
    },
    transform: {
        text: `Transform`,
        svg: `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-repeat" viewBox="0 0 16 16"><path d="M11.534 7h3.932a.25.25 0 0 1 .192.41l-1.966 2.36a.25.25 0 0 1-.384 0l-1.966-2.36a.25.25 0 0 1 .192-.41m-11 2h3.932a.25.25 0 0 0 .192-.41L2.692 6.23a.25.25 0 0 0-.384 0L.342 8.59A.25.25 0 0 0 .534 9"/><path fill-rule="evenodd" d="M8 3c-1.552 0-2.94.707-3.857 1.818a.5.5 0 1 1-.771-.636A6.002 6.002 0 0 1 13.917 7H12.9A5 5 0 0 0 8 3M3.1 9a5.002 5.002 0 0 0 8.757 2.182.5.5 0 1 1 .771.636A6.002 6.002 0 0 1 2.083 9z"/></svg>`,
    },
};

customElements.define('func-text-button', FuncTextButton);
customElements.define('func-icon-button', FuncIconButton);
