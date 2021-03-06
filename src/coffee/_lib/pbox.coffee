ing = undefined



HTML = $('HTML')[0]

$.pbox = (html, option={})->
    HTML_CLS = HTML.className
    if ing
        return

    ing = 1
    doc = $(document)
    option = {
        className:"PboxMain"
        ico:"close"
        keyup:(keyCode, tagName)->
            if tagName != "TEXTAREA" and tagName != "INPUT"
                if keyCode == 27
                    rm()
            return
        ...option
    }
    className = option.className
    elem = $("""<div class="Pbox #{option.classPbox or ''}"><div class="C macS"><div class="#{className}"></div></div><i class="PboxIco I I-#{option.ico}"></i></div>""")
    elem.find('.'+className).html html
    $('body').append(elem)

    macS = elem.find('.macS')[0]
    macS.scrollbar = scrollbar = $.scrollbar macS
    keyup = 'keyup.box'
    _title = document.title
    rm = ->
        delete elem[0].rm
        event = jQuery.Event("rm")
        elem.trigger(event)
        # c = option.rm
        # if c
        #     if c.call(@, _rm) == false
        #         return
        if not event.isDefaultPrevented()
            _rm()
        return false

    _rm = ->
        HTML.className = HTML_CLS
        document.title = _title
        setTimeout ->
            event = jQuery.Event("rmed")
            elem.trigger(event)
            elem.remove()
            doc.unbind(keyup)
            scrollbar.destroy()


    rm_btn = elem.find('.I-'+option.ico).click rm

    elem0 = elem[0]
    elem0._rm = _rm
    elem0.rm = rm

    doc.bind(
        keyup
        (e)->
            tagName = e.target.tagName
            option.keyup(e.keyCode, tagName)
            return
    )
    ing = undefined
    elem.option = option
    return elem
