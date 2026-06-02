import vue from '@vitejs/plugin-vue'
import Inspector from 'vite-plugin-vue-inspector'

import createAutoImport from './auto-import'
import createSvgIcon from './svg-icon'
import createCompression from './compression'
import createSetupExtend from './setup-extend'

export default function createVitePlugins(viteEnv, isBuild = false) {
    const vitePlugins = [vue()]
    vitePlugins.push(createAutoImport())
    vitePlugins.push(createSetupExtend())
    vitePlugins.push(createSvgIcon(isBuild))

    if (!isBuild) {
        vitePlugins.push(
            Inspector({
                enabled: true,
                toggleKeyCombo: 'meta-shift',
                showDevtools: true,
                appName: 'RuoYi-Vue3',
                launchEditor: 'cursor'
            })
        )
    }

    isBuild && vitePlugins.push(...createCompression(viteEnv))
    return vitePlugins
}
