$ ->

  translations = ->

    # Hides or shows the + button and the remove button.
    updateLocaleButtonsStatus = ($dom) ->
      $localeList = $dom.find('.add-locale ul li:not(.hidden)')
      if ($localeList.length == 0)
        $dom.find('.add-locale').hide()
      else
        $dom.find('.add-locale').show()

      $tabs = $dom.children('li:not(.add-locale)').find('a:not(.hidden)')
      if ($tabs.length > 1)
        $tabs.find('span').removeClass('hidden')
      else
        $tabs.find('span').addClass('hidden')

    # Hides or shows the locale tab and its corresponding element in the add menu.
    toggleTab = ($tab, active) ->
      $addButton = $tab.parents('ul').find('.add-locale li:has(a[href="' + $tab.attr('href') + '"])')
      if active
        $tab.addClass('hidden').show().removeClass('hidden')
        $addButton.hide().addClass('hidden')
      else
        $tab.addClass('hidden').hide().addClass('hidden')
        $addButton.show().removeClass('hidden')

    $(".activeadmin-translations > ul").each ->
      $dom = $(this)
      if !$dom.data("ready")
        $dom.data("ready", true)
        $tabs = $("li > a", this)
        $contents = $(this).siblings("fieldset")

        $tabs.click (e) ->
          $tab = $(this)
          $tabs.not($tab).removeClass("active")
          $tab.addClass("active")
          $contents.hide()
          $contents.filter($tab.attr("href")).show()
          e.preventDefault()

        $tabs.eq(0).click()

        # Collect tha available locales.
        availableLocales = []
        $tabs.each ->
          availableLocales.push($('<li></li>').append($(this).clone().removeClass('active')))

        # Create a new tab as the root of the drop down menu.
        $addLocaleButton = $('<li class="add-locale"><a href="#">+</a></li>')
        $addLocaleButton.append($('<ul></ul>').append(availableLocales))

        # Handle locale addition
        $addLocaleButton.find('ul a').click (e) ->
          href = $(this).attr('href')
          $tab = $tabs.filter('[href="' + href + '"]')
          toggleTab($tab, true)
          $tab.click()
          updateLocaleButtonsStatus($dom)
          e.preventDefault()

        # Remove a locale from the tab.
        $removeButton = $('<span class="remove">x</span>').click (e) ->
          e.stopImmediatePropagation()
          e.preventDefault()
          $tab = $(this).parent()
          toggleTab($tab, false)
          if $tab.hasClass('active')
            $tabs.not('.hidden').eq(0).click()

          updateLocaleButtonsStatus($dom)

        # Add the remove button to every tab.
        $tabs.append($removeButton)

        # Add the new button at the end of the locale list.
        $dom.append($addLocaleButton)

        numberOfHidden = 0
        $tabs.each ->
          $tab = $(@)
          $content = $contents.filter($tab.attr("href"))
          containsErrors = $content.find(".input.error").length > 0
          $tab.toggleClass("error", containsErrors)
          # Find those tabs that are in use.
          hide = true
          # We will not hide the tabs that have any error.
          if $tab.hasClass('error')
            hide = false
          else
            # Check whether the input fields are empty or not.
            $content.find('[name]').not('[type="hidden"]').each ->
              if $(this).val()
                # We will not hide the tab because it has some data.
                hide = false
                return false

          if hide
            numberOfHidden++
            toggleTab($tab, false)
          else
            toggleTab($tab, true)

        # Every tab became hidden, show the first one.
        if numberOfHidden == $tabs.length
          $tabs.eq(0).show().removeClass('hidden')
          $addLocaleButton.find('li:has(a[href="' + $tabs.eq(0).attr('href') + '"])').hide().addClass('hidden')

        # Remove the fields of those locales before form submission that have not been added.
        $dom.parents('form').submit ->
          $tabs.each ->
            if $(this).hasClass('hidden')
              $($(this).attr('href')).remove()

        #Initially update the buttons' status
        updateLocaleButtonsStatus($dom)

  # this is to handle elements created with has_many
  $("a").bind "click", ->
    setTimeout(
      -> translations()
      50
    )

  translations()

