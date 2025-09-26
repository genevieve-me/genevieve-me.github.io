My Zola-based website and nascent blog.

## Structure

We want to have the same header on every page, so everything extends <templates/base.html>, which contains `partials/header.html`.

Special templates:
- <templates/index.html> for the homepage, found at `/`
- <templates/blog.html> for the list of all posts, found at `/blog`

## Inspiration

Blog structure is heavily based on Linkita/Hugo Paper. CSS is done in more of a 'CSS Zen Garden' (semantic components) way vs the Tailwind/CSS utility classes way done by those though. Maybe with more practice with CSS I would learn more pros of the latter style, but using the former helped me keep my tiny site in my head.

#### Tutorials/Themes

- <https://endtimes.dev/no-javascript-dark-mode-toggle/>
- <https://www.youtube.com/watch?v=gahb6jZ_HXM>
- <https://niqwithq.com/posts/the-design-of-visited-links>
- <https://codepen.io/ditheringidiot/pen/JjbzNMz>
- <https://salif.github.io/linkita/en/about/>

Websites I Like
- <https://github.com/enricozb/enricozb.github.io>
- <https://grayolson.com/>

Inspiration for a dropdown navigation menu on mobile:
- <https://logicmatters.net>
- <https://mmhaskell.com>
- <https://viralinstruction.com>

## Features (table stakes)

- Dark/light themes with `@media` queries
- Responsive design for mobile and desktop. take up no more than 70 characters, never go past viewport on mobile, but also at least 30% of viewport on desktop? clamp?

## Goals

Dark mode toggle with JavaScript that fails gracefully if JS is disabled

popover instead of checkbox hack?
- <https://developer.chrome.com/blog/introducing-popover-api/>
- <https://news.ycombinator.com/item?id=36055536>

hide the header when scrolling down on mobile with JS?
- <https://www.patrickthurmond.com/blog/2023/11/20/how-to-show-and-hide-elements-on-scroll>

header is transparent on mobile
- not looked into yet

include footer only on some pages
- we cannot check a variable on base.html because on some pages section is not defined and on others page is not defined
- can we put something in the frontmatter as a directive? what if it's not defined?

# Check performance

https://treo.sh/sitespeed/
lighthouse
https://pagespeed.web.dev/
https://www.webpagetest.org/
