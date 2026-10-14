import vue from '@vitejs/plugin-vue'
import Inspector from 'vite-plugin-vue-inspector'

import createAutoImport from './auto-import'
import createSvgIcon from './svg-icon'
import createCompression from './compression'
import createSetupExtend from './setup-extend'

function createHoldToInspect() {
    return {
        name: 'hold-to-inspect',
        transformIndexHtml() {
            return [{
                tag: 'script',
                injectTo: 'body',
                children: `
                    (() => {
                        const isMac = /Mac|iPhone|iPad|iPod/.test(navigator.platform)
                        const isShortcutPressed = (event) => event.shiftKey && (isMac ? event.metaKey : event.ctrlKey)
                        const enableInspector = (event) => {
                            if (isShortcutPressed(event))
                                window.__VUE_INSPECTOR__?.enable()
                        }
                        const disableInspector = (event) => {
                            if (!event || !isShortcutPressed(event))
                                window.__VUE_INSPECTOR__?.disable()
                        }

                        window.addEventListener('keydown', enableInspector, true)
                        window.addEventListener('keyup', disableInspector, true)
                        window.addEventListener('blur', () => disableInspector(), true)
                        document.addEventListener('visibilitychange', () => {
                            if (document.hidden)
                                disableInspector()
                        })
                    })()
                `
            }]
        }
    }
}

export default function createVitePlugins(viteEnv, isBuild = false) {
    const vitePlugins = [vue()]
    vitePlugins.push(createAutoImport())
    vitePlugins.push(createSetupExtend())
    vitePlugins.push(createSvgIcon(isBuild))

    if (!isBuild) {
        vitePlugins.push(
            Inspector({
                enabled: false,
                toggleComboKey: false,
                toggleButtonVisibility: 'never',
                launchEditor: 'code'
            }),
            createHoldToInspect()
        )
    }

    isBuild && vitePlugins.push(...createCompression(viteEnv))
    return vitePlugins
}
