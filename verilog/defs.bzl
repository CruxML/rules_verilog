VerilogModuleInfo = provider(
    doc = "Info pertaining to Verilog module.",
    fields = {
        "top": "Top module name.",
        "files": "A depset of all necessary Verilog files.",
    },
)

def _verilog_module_impl(ctx):
    runfiles = ctx.runfiles(files = ctx.files.data)

    # , transitive_files = [
    #     dep[DefaultInfo].runfiles
    #     for dep in ctx.attr.deps
    # ])
    return [
        DefaultInfo(runfiles = runfiles),
        VerilogModuleInfo(
            top = ctx.attr.top,
            files = depset(
                direct = ctx.files.srcs,
                transitive = [dep[VerilogModuleInfo].files for dep in ctx.attr.deps],
            ),
        ),
    ]

verilog_module = rule(
    implementation = _verilog_module_impl,
    doc = "Verilog module.",
    attrs = {
        "srcs": attr.label_list(
            doc = "(System) verilog source files.",
            allow_files = [".v", ".sv"],
        ),
        "data": attr.label_list(
            doc = "Data files.",
            allow_files = True,
        ),
        "top": attr.string(
            doc = "Top module name.",
            mandatory = True,
        ),
        "deps": attr.label_list(
            doc = "Verilog module dependencies.",
            providers = [
                DefaultInfo,
                VerilogModuleInfo,
            ],
        ),
    },
)
