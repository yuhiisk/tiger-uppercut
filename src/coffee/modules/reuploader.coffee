do (win = window, doc = window.document) ->

    'use strict'

    Events = win.Staircase.ns('Events')
    Util = win.Staircase.ns('Util')
    UI = win.Staircase.ns('UI')

    # serverから返ってくる画像の幅
    ORIGINAL_IMAGE_WIDTH = 640

    ###
    # Re-Uploader
    # @constructor
    # @extends EventEmitter2
    # @params {object} options
    ###
    class ReUploader extends EventEmitter2

        constructor: (option) ->

            super(option)

            @size = option.size || ORIGINAL_IMAGE_WIDTH # 表示サイズ
            @expansion = ORIGINAL_IMAGE_WIDTH / @size # 拡大比率

            @initialize()
            @eventify()

        initialize: () ->

            @$form = $('#Adjust')
            @$imageFrame = $('.transform__image')
            @$image = $('img', @$imageFrame)

        eventify: () ->

            @$form.on('submit', (e) =>
                e.preventDefault()
                @submit()
            )

        submit: () ->

            ratio = @$image.width() / @size + (UI.TRIM_RATIO - 1)

            params =
                image_uuid: Util.getImageId()
                zoom: ratio # 拡大比率
                x: (UI.TRIM_OFFSET_LEFT * UI.TRIM_RATIO) + Math.abs(@$imageFrame.position().left) * @expansion
                y: (UI.TRIM_OFFSET_TOP * UI.TRIM_RATIO) + Math.abs(@$imageFrame.position().top) * @expansion
                width: UI.TRIM_WIDTH
                height: UI.TRIM_HEIGHT

            @emit(Events.REUPLOAD_SUBMIT, null, params)

            $.ajax(
                type: 'POST'
                url: @$form.attr('action')
                data: params
            ).done((e) =>
                @emit(Events.REUPLOAD_SUCCESS, null, e)
            ).fail((e) =>
                @emit(Events.REUPLOAD_ERROR, null, e)
            )

    UI.ReUploader = ReUploader

