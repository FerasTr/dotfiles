const main = "/tmp/ags/js/greeter.js"
const entry = `${App.configDir}/greeter/greeter.ts`

try {
    await Utils.execAsync([
        "esbuild", "build", entry,
        "--outfile", main,
        "--external", "resource://*",
        "--external", "gi://*",
        "--external", "file://*",
    ])
    await import(`file://${main}`)
} catch (error) {
    console.error(error)
    App.quit()
}

export { }
