(function ($) {

    "use strict";

    var mainApp = {

        main_fun: function () {

            /*
             CUSTOM LINKS SCROLL FUNCTION
            */

            $('nav a[href*=#]').click(function () {

                if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '')
               && location.hostname == this.hostname) {

                    var $target = $(this.hash);

                    $target = $target.length && $target
                    || $('[name=' + this.hash.slice(1) + ']');
                    
                    if ($target.length) {

                        var targetOffset = $target.offset().top;
                        
                        $('html,body')
                        
                        .animate({ scrollTop: targetOffset }, 800); //set scroll speed here
                        
                        return false;
                    }
                }
            });

            /*
                NAVBAR SCRIPT
            */

            $(window).bind('scroll', function () {

                var navHeight = $(window).height() -50;

                if ($(window).scrollTop() > navHeight) {

                    $('nav').addClass('fixed');
                }

                else {

                    $('nav').removeClass('fixed');
                }
            });

        },

        initialization: function () {
            mainApp.main_fun();

        }

    }

    // Beep Boop. Boop Beep? //

    $(document).ready(function () {
        mainApp.main_fun();
    });

}(jQuery));
