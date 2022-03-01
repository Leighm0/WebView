(this["webpackJsonpreact-markdown-documentation"] = this["webpackJsonpreact-markdown-documentation"] || []).push([
    [0],
    {
        172: function (e, t, r) {},
        173: function (e, t, r) {},
        549: function (e, t, r) {
            "use strict";
            r.r(t);
            var n = r(19),
                a = r(0),
                c = r.n(a),
                o = r(18),
                l = r.n(o),
                i = (r(172), r(164)),
                s = (r(173), r(583)),
                d = r(162),
                u = r.n(d),
                h = r(572),
                b = r(574),
                p = r(585),
                j = r(575),
                m = r(576),
                g = r(577),
                f = r(578),
                x = r(579),
                O = r(580),
                v = r(581),
                y = r(147),
                k = r.n(y),
                w = r(584),
                C = r(571),
                E = r(6);
            function N(e) {
                var t = /language-(\w+)/.exec(e.className || "");
                if (e.inline) return Object(E.jsx)("code", Object(n.a)({ style: { background: "#CEEEEE" } }, e));
                var r = t ? t[1] : "text";
                return Object(E.jsx)(w.a, Object(n.a)({ style: C.a, language: r, PreTag: "pre", children: String(e.children).replace(/\n$/, "") }, e));
            }
            function S() {
                return "_self" in c.a.createElement("div");
            }
            var T = r(152),
                q = r.n(T),
                B = r(153),
                I = r.n(B);
            function z(e) {
                return e["data-sourcepos"] ? { "data-sourcepos": e["data-sourcepos"] } : {};
            }
            function D(e) {
                function t(e) {
                    var t = c.a.Children.toArray(e.children).reduce(function e(t, r) {
                            return "string" === typeof r ? t + r : c.a.Children.toArray(r.props.children).reduce(e, t);
                        }, ""),
                        r = t
                            .replace(/\s+/g, "-")
                            .replace(/\./g, "-")
                            .replace(/-+/g, "-")
                            .replace(/-$/g, "")
                            .replace(/(?<=\d)-(\d)/g, "$1")
                            .replace(/[|@#!&*]/g, "")
                            .toLowerCase(),
                        n = e.level > 1 ? { marginTop: "5px", marginBottom: "5px" } : { marginBottom: "5px" };
                    return Object(E.jsx)(h.a, { id: "head-" + r, variant: "h".concat(e.level + 1), color: "primary", style: n, children: e.children });
                }
                function r(e) {
                    var t = z(e);
                    return null !== e.start && 1 !== e.start && void 0 !== e.start && (t.start = e.start.toString()), c.a.createElement(e.ordered ? "ol" : "ul", t, e.children);
                }
                function a(e) {
                    return Object(E.jsx)("li", { children: Object(E.jsx)(h.a, Object(n.a)(Object(n.a)({ component: "span" }, z(e)), {}, { variant: "body2", children: e.children })) });
                }
                var o = function (e) {
                    var t = Object(b.a)({ disableHysteresis: !0, threshold: 100 });
                    return Object(E.jsx)(p.a, {
                        in: t,
                        children: Object(E.jsx)("div", {
                            onClick: function (e) {
                                var t = (e.target.ownerDocument || document).querySelector("#back-to-top-anchor");
                                t && t.scrollIntoView({ behavior: "smooth", block: "center" });
                            },
                            role: "presentation",
                            style: { position: "fixed", bottom: "20px", right: "20px", zIndex: 9e3 },
                            children: e.children,
                        }),
                    });
                };
                return Object(E.jsxs)("div", {
                    style: { padding: "10px", paddingLeft: "20px" },
                    children: [
                        Object(E.jsx)("div", { id: "back-to-top-anchor" }),
                        Object(E.jsx)(k.a, {
                            plugins: [q.a, I.a],
                            className: "result",
                            components: {
                                a: function (e) {
                                    var t = "footnote-backref" === e.className ? e.href.substring(1, 3) + e.href.substring(6) : null;
                                    return Object(E.jsx)("span", {
                                        id: t,
                                        onClick: function (t) {
                                            var r = null;
                                            e.href.startsWith("http") || e.href.startsWith("www")
                                                ? window.open(e.href, "_blank")
                                                : (r =
                                                      "footnote-backref" === e.className || "footnote-ref" === e.className
                                                          ? (t.target.ownerDocument || document).querySelector(e.href)
                                                          : (t.target.ownerDocument || document).querySelector("#head-" + e.href.substring(1))) && r.scrollIntoView({ behavior: "smooth", block: "start" });
                                        },
                                        style: { cursor: "pointer", color: "blue", textDecoration: "underline" },
                                        children: e.children,
                                    });
                                },
                                blockquote: "blockquote",
                                code: N,
                                em: "em",
                                h1: t,
                                h2: t,
                                h3: t,
                                h4: t,
                                h5: t,
                                h6: t,
                                br: "br",
                                hr: "hr",
                                img: function (e) {
                                    var t = "..".concat(e.src.substring(1)),
                                        r = "..".concat(e.alt.substring(1));
                                    return S() && ((t = e.src), (r = e.alt)), Object(E.jsx)("img", { style: { maxWidth: "calc(100vw - 40px)" }, alt: r, src: t });
                                },
                                ul: r,
                                ol: r,
                                li: a,
                                input: function (e) {
                                    return Object(E.jsx)(s.a, { checked: e.checked, disabled: !0, size: "small", style: { padding: "3px" } });
                                },
                                p: function (e) {
                                    return Object(E.jsx)(h.a, { style: { marginBottom: "8pt", marginTop: "8pt" }, variant: "body1", children: e.children });
                                },
                                pre: "div",
                                strong: "strong",
                                thematicBreak: "hr",
                                del: "del",
                                heading: t,
                                list: r,
                                listItem: a,
                                table: function (e) {
                                    return Object(E.jsx)(j.a, { children: Object(E.jsx)(m.a, { children: e.children }) });
                                },
                                thead: g.a,
                                tbody: f.a,
                                tr: x.a,
                                td: O.a,
                                th: O.a,
                                dl: "dl",
                                dt: "dt",
                                dd: "dd",
                            },
                            children: e.source,
                        }),
                        Object(E.jsx)(o, { children: Object(E.jsx)(v.a, { color: "primary", size: "small", "aria-label": "scroll back to top", children: Object(E.jsx)(u.a, { style: { color: "white" } }) }) }),
                    ],
                });
            }
            var M = function () {
                    var e = c.a.useState(""),
                        t = Object(i.a)(e, 2),
                        r = t[0],
                        n = t[1],
                        o = S() ? "./documentation.md" : "../documentation.md";
                    return (
                        Object(a.useEffect)(
                            function () {
                                fetch(o)
                                    .then(function (e) {
                                        return e.text();
                                    })
                                    .then(function (e) {
                                        n(e);
                                    });
                            },
                            [o]
                        ),
                        Object(E.jsx)("div", { className: "result-pane", children: Object(E.jsx)(D, { className: "result", source: r }) })
                    );
                },
                W = r(582),
                $ = r(163),
                A = r(65),
                G = r(1),
                J = {
                    props: { MuiTableCell: { align: "left" } },
                    overrides: {
                        MuiTableCell: {
                            head: Object(n.a)({ backgroundColor: G.a.blueGray.lighter, textTransform: "uppercase" }, A.a.typography.caption),
                            body: Object(n.a)(Object(n.a)({ padding: G.b.normal }, A.a.typography.body1), {}, { color: G.a.blueGray.dark, fontSize: "1rem" }),
                        },
                        MuiTableRow: { root: { "&:nth-of-type(even)": { backgroundColor: "rgba(0, 0, 0, 0.02)" }, "&:hover": { backgroundColor: "rgba(3, 169, 244, 0.1)" } } },
                    },
                },
                L = Object($.a)(A.a, J);
            l.a.render(Object(E.jsx)(W.a, { theme: L, children: Object(E.jsx)(M, {}) }), document.getElementById("root"));
        },
    },
    [[549, 1, 2]],
]);
