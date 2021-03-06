DRAFT = "draft"
DRAFT_KEY = "$"
DRAFT_ICO = " "


ACTION = {
    $: (elem)->
        return elem.text()+DRAFT_ICO
}




select_html = (file, callback)->
    PP.get(
        "post/dir"
        (txt)->
            _ = $.html()
            t = """<div class="li v" data-v="%v">%cn<i class="I I-%en"></i></div>"""
            v = DRAFT_KEY
            cn = '草稿箱'
            if file.startsWith(v+"/")
                val = v
                text = cn
            _ t.render({cn,en:DRAFT,v})
            if txt
                for i in txt.split("\n")
                    [dir, name] = i.split("\r")
                    if file.startsWith(dir+"/")
                        val = dir
                        text = name
                    _ _select(dir,name)
            _ t.render({cn:'新建章节',en:"add",v:""})
            callback $(_.html()), val, text
    )

_select = (dir, name)->
    return """<div class=li><b class="v" data-v="#{$.escape dir}">#{$.escape name}</b><i class="I I-edit IBtn"></i></div>"""

module.exports = System.import("coffee/_site/edit/_slide").then (slideout)->
    slideout (resolve, {file, editor, h1, box})->
        html = $ require('./fly.slm')
        input = html.find('input.select')
        select_html file, (select, val, text)->
            if val == DRAFT_KEY
                text = text + DRAFT_ICO
            input.val text
            input[0].dataset.v = val


            ACTION[""] = (elem)->
                System.import("coffee/_site/edit/blog/_box/dir").then(
                    (mod)=>
                        mod().done (dir, name)=>
                            @val name
                            @[0].dataset.v =  dir
                            select.splice(-1,0,$(_select(dir, name))[0])
                            return
                )
                return [@[0].dataset.v, @val()]


            require("coffee/_lib/select")(
                input
                select
                (input)->
                    v = @data('v')+''
                    if v of ACTION
                        return ACTION[v].call input, @
                (input)->
                    @find('.I-edit').click ->
                        b = @previousSibling
                        v = b.dataset.v
                        input0 = input[0]
                        System.import("coffee/_site/edit/blog/_box/dir").then (mod)=>
                            mod(
                                b.innerText
                                b.dataset.v
                            ).then (dir, name)=>
                                if input0.dataset.v == b.dataset.v
                                    input0.dataset.v = dir
                                    input.val(name)
                                if dir
                                    b.dataset.v = dir
                                    b.innerText = name
                                else
                                    $(@).closest('.li').remove()

            )
            html.find('input.btn').click ->
                System.import("coffee/_site/edit/save.coffee").then(
                    (mod)->
                        opt = {}
                        dir = input[0].dataset.v
                        if dir != undefined
                            opt.dir = dir
                        mod(
                            file
                            h1.val()
                            editor.getContent()
                            opt
                        ).done (url)->
                            box[0]._rm()
                            GO.push "-/"+url
                )
            resolve html
