Changes
  renamed RewardsMenu to just rewards
  added "main" container
    for sizing and responsivness
    sized main container
      with a "max-width"
        max-width: 1200px;
        the max width is the same as
        the width that it changes to the mobile layout at
        max-width will allow the content to shrink on
        smaller displays while at not getting stretched out on larger displays
      and margin
        adding a top margin of 145px to make room for the navbar
        adding auto margins on both sidesto center the content
        adding an @media attribute to chnage the margins when the width of the screen changes
        margin: 145px auto 0 auto;
        @media only screen and (max-width: 1200px)
          .main[data-v-d16d3411] {
              margin: 0 auto 0 auto;
          }
        }
  removed top divider "it was not on the other pages"
  did not set page margins with the margins of elements
    instead set the margins of the page with a page wrapper
  set page dividers with height and width rather than a border
  added more margin between elements
  added cursor: pointer;
    to items
  added a "transsition: all 120ms" property to all elements
    that change on hover
  added position:reletive to items
    so the outside item of "Click to learn more"
    can be set to absolute
  set image of unknown logo
    to grey blured circles
    set width
    aspect ratio
    filter: blur(6px);
    background-color: gray;
  created a "Click to learn more" element
  changed redeem cart button to green
  Put the data in a constants file
making page responsive
  reduced number of columns depending on screen width
  find where elements collide and change rows to columns
    -separating row elements considering how you would transform them to columns
  removed grid row number
  rows are dynamically created
    added "main" container
  for sizing and responsivness
  sized main container
    with a "max-width"
      max-width: 1200px;
      the max width is the same as
      the width that it changes to the mobile layout at
      max-width will allow the content to shrink on
      smaller displays while at not getting stretched out on larger displays
    and margin
      adding a top margin of 145px to make room for the navbar
      adding auto margins on both sidesto center the content
      adding an @media attribute to chnage the margins when the width of the screen changes
      margin: 145px auto 0 auto;
      @media only screen and (max-width: 1200px)
        .main[data-v-d16d3411] {
            margin: 0 auto 0 auto;
        }
      }
  fix nav bar
      I have no clue what was rwrong with this