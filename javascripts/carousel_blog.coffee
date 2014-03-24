class CarouselBlog
  initialize : ()->
    init_region = $("article.region").eq(0)

    this.init_article_keyframes()
    this.resize_articles()

    $("article.region").click (e)=>
      $elm = $(e.currentTarget)
      $("article.region").removeClass("selected").addClass("unselected")
      $elm.removeClass("unselected").addClass("selected")
      $("section#mainland").animate(
        top : 85 - $elm.position().top
      )
      _this.resize_articles()

    $(document).keydown (e)=>
      if e.keyCode == 40
        $("article.region.selected").next().trigger("click")
      else if e.keyCode == 38
        $("article.region.selected").prev().trigger("click")

  # create keyframe for each article
  init_article_keyframes : ()=>
    $.each $("article.region"), (i, elm)=>
      end_value = 1 - Math.abs(10 * i) / 100
      this.create_keyframe("scale_#{i}", "scale", "0", "#{end_value}")

  resize_articles : ()=>
    current_region = $("article.region.selected").data("index")
    $.each $("article.region"), (i, elm)=>
      new_transform = 1 - Math.abs(10 * (i - current_region)) / 100

      # get translate values
      matrixRegex = /matrix\((-?\d*\.?\d+),\s*0,\s*0,\s*(-?\d*\.?\d+),\s*0,\s*0\)/
      matches = $(elm).css("-webkit-transform").match(matrixRegex)
      translate_x = matches[1]
      translate_y = matches[2]

      # console.log("FROM: #{translate_x}, TO: #{new_transform}")

      keyframe = "scale_#{i}"

      this.update_keyframe(
        "#{keyframe}",
        "scale",
        "#{translate_x},#{1}",
        "#{new_transform},#{1}"
      )

      $(elm).attr("style","-webkit-transform:scale(#{translate_x},#{1})")

      setTimeout ()=>
        $(elm).css(
          "-webkit-animation" : "#{keyframe} 500ms"
        ).one("webkitAnimationEnd", ()->
          $(elm).css("-webkit-transform","scale(#{new_transform},#{1})")
        )
      , 100

  create_keyframe : (name, property, from, to)->
    # just grab the first one
    sheet = document.styleSheets[0]
    keyframes = "@-webkit-keyframes #{name} {" +
                "  0% {-webkit-transform: scale(#{from}) }" + 
                "100% {-webkit-transform: scale(#{to}) }" +
                "}"
    sheet.insertRule(keyframes, 0)

  # FIXME: Probably not correct
  find_keyframe : (name)->
    sheet = document.styleSheets
    # sift through and find the -webkit-keyframes rule with name specified
    for i in [0..document.styleSheets.length-1]
      sheet = document.styleSheets[i]
      for j in [0..sheet.cssRules.length-1]
        if (sheet.cssRules[j].type == window.CSSRule.WEBKIT_KEYFRAMES_RULE && sheet.cssRules[j].name == name)
          return sheet.cssRules[j]
    return null

  show_keyframes : (name)->
    sheet = document.styleSheets
    # sift through and find the -webkit-keyframes rule with name specified
    for i in [0..document.styleSheets.length-1]
      sheet = document.styleSheets[i]
      for j in [0..sheet.cssRules.length-1]
        if (sheet.cssRules[j].type == window.CSSRule.WEBKIT_KEYFRAMES_RULE)
          console.log(sheet.cssRules[j])

  update_keyframe : (name, property, from, to)->
    kf = this.find_keyframe(name)
    # remove existing rules
    kf.deleteRule("0%")
    kf.deleteRule("100%")
    # create new from and to rules
    kf.insertRule("0% {-webkit-transform: scale(#{from})}")
    kf.insertRule("100% {-webkit-transform: scale(#{to})}")

this.CarouselBlog = new CarouselBlog