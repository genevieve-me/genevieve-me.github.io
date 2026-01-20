// Vendored from https://github.com/stuxf/basic-typst-resume-template/blob/main/src/resume.typ
// to override margins

#import "@preview/scienceicons:0.1.0": github-icon, linkedin-icon, orcid-icon, website-icon

#let resume(
  author: "",
  author-position: left,
  personal-info-position: left,
  pronouns: "",
  location: "",
  email: "",
  github: "",
  linkedin: "",
  phone: "",
  personal-site: "",
  orcid: "",
  accent-color: "#000000",
  font: "New Computer Modern",
  paper: "us-letter",
  author-font-size: 20pt,
  font-size: 10pt,
  lang: "en",
  body,
) = {

  // Sets document metadata
  set document(author: author, title: author)

  // Document-wide formatting, including font and margins
  set text(
    // LaTeX style font
    font: font,
    size: font-size,
    lang: lang,
    // Disable ligatures so ATS systems do not get confused when parsing fonts.
    ligatures: false
  )

  let content = {
    // Link styles
    show link: underline


    // Small caps for section titles
    show heading.where(level: 2): it => [
      #pad(top: 0pt, bottom: -10pt, [#smallcaps(it.body)])
      #line(length: 100%, stroke: 1pt)
    ]

    // Accent Color Styling
    show heading: set text(
      fill: rgb(accent-color),
    )

    show link: set text(
      fill: rgb(accent-color),
    )

    // Name will be aligned left, bold and big
    show heading.where(level: 1): it => [
      #set align(author-position)
      #set text(
        weight: 700,
        size: author-font-size,
      )
      #pad(it.body)
    ]

    // Level 1 Heading
    [= #(author)]

    // Personal info helpers
    let contact-item(value, prefix: "", link-type: "") = {
      if value != "" {
        if link-type != "" {
          link(link-type + value)[#(prefix + value)]
        } else {
          prefix + value
        }
      }
    }

    let icon-link-item(
      value,
      icon: none,
      scheme: "https://",
      label: none,
      icon-color: accent-color,
      gap: 0.25em,
    ) = {
      if value == "" {
        none
      } else {
        let icon-content = if icon == none { none } else { icon(color: rgb(icon-color)) }
        let label-text = if label == none { value } else { label }
        link(scheme + value)[
          #if icon-content != none [
            #icon-content
            #if gap != 0em [
              #h(gap)
            ]
          ]
          #label-text
        ]
      }
    }

    let join-content(items, separator: text("  |  ")) = {
      if items.len() == 0 {
        none
      } else {
        [
          #for (index, item) in items.enumerate() [
            #if index > 0 [
              #separator
            ]
            #item
          ]
        ]
      }
    }

    // Personal Info
    pad(
      top: 0.25em,
      align(personal-info-position)[
        #{
          let contact-line = (
            contact-item(pronouns),
            contact-item(location),
            contact-item(phone),
            contact-item(email, link-type: "mailto:"),
          ).filter(x => x != none)

          let links-line = join-content((
            icon-link-item(
              personal-site,
              icon: website-icon,
            ),
            icon-link-item(
              linkedin,
              icon: linkedin-icon,
            ),
            icon-link-item(
              github,
              icon: github-icon,
            ),
            icon-link-item(
              orcid,
              icon: orcid-icon,
              scheme: "https://orcid.org/",
              label: if orcid != "" { "orcid.org/" + orcid } else { none },
              icon-color: "#AECD54",
              gap: 0em,
            ),
          ).filter(x => x != none))

          [
            #if contact-line.len() > 0 [
              #(contact-line.join("  |  "))
            ]
            #if contact-line.len() > 0 and links-line != none [
              #linebreak()
            ]
            #if links-line != none [
              #links-line
            ]
          ]
        }
      ],
    )

    // Main body.
    set par(justify: true)

    body
  }

  // Recommended to have 0.5in margin on all sides
  if sys.inputs.at("target", default: "pdf") != "html" {
    set page(
      margin: (0.6in),
      paper: paper,
    )
    content
  } else {
    content
  }
}

// Generic two by two component for resume
#let generic-two-by-two(
  top-left: "",
  top-right: "",
  bottom-left: "",
  bottom-right: "",
) = {
  [
    #top-left #h(1fr) #top-right \
    #bottom-left #h(1fr) #bottom-right
  ]
}

// Generic one by two component for resume
#let generic-one-by-two(
  left: "",
  right: "",
) = {
  [
    #left #h(1fr) #right
  ]
}

// Cannot just use normal --- ligature becuase ligatures are disabled for good reasons
#let dates-helper(
  start-date: "",
  end-date: "",
) = {
  start-date + " " + $dash.em$ + " " + end-date
}

// Section components below
#let edu(
  institution: "",
  dates: "",
  degree: "",
  gpa: "",
  location: "",
  // Makes dates on upper right like rest of components
  consistent: false,
) = {
  if consistent {
    // edu-constant style (dates top-right, location bottom-right)
    generic-two-by-two(
      top-left: strong(institution),
      top-right: dates,
      bottom-left: emph(degree),
      bottom-right: emph(location),
    )
  } else {
    // original edu style (location top-right, dates bottom-right)
    generic-two-by-two(
      top-left: strong(institution),
      top-right: location,
      bottom-left: emph(degree),
      bottom-right: emph(dates),
    )
  }
}

#let work(
  title: "",
  dates: "",
  company: "",
  location: "",
) = {
  generic-two-by-two(
    top-left: strong(title),
    top-right: dates,
    bottom-left: company,
    bottom-right: emph(location),
  )
}

#let project(
  role: "",
  name: "",
  url: "",
  dates: "",
) = {
  generic-one-by-two(
    left: {
      if role == "" {
        [*#name* #if url != "" and dates != "" [ (#link("https://" + url)[#url])]]
      } else {
        [*#role*, #name #if url != "" and dates != ""  [ (#link("https://" + url)[#url])]]
      }
    },
    right: {
      if dates == "" and url != "" {
        link("https://" + url)[#url]
      } else {
        dates
      }
    },
  )
}

#let certificates(
  name: "",
  issuer: "",
  url: "",
  date: "",
) = {
  [
    *#name*, #issuer
    #if url != "" [
      (#link("https://" + url)[#url])
    ]
    #h(1fr) #date
  ]
}

#let extracurriculars(
  activity: "",
  dates: "",
) = {
  generic-one-by-two(
    left: strong(activity),
    right: dates,
  )
}
