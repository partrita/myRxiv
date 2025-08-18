#let sans_font = "Noto Sans KR"
#let serif_font = "Noto Serif KR"
#let mono_font = "JBD2"

#let template(
  // 논문의 제목
  title: "Paper Title",
  subtitle: none,

  // 저자 배열. 각 저자에 대해 이름, orcid, 소속을 지정할 수 있습니다.
  // 소속은 콘텐츠여야 하며, 예: "1", 위첨자로 표시되고 소속 목록과 일치해야 합니다.
  // 이름을 제외한 모든 것은 선택사항입니다.
  authors: (),
  // 소속 목록입니다. 각 소속에 id와 `name`을 포함하세요. 저자 아래에 표시됩니다.
  affiliations: (),
  // 논문의 초록. 없으면 생략할 수 있습니다.
  abstract: none,
  // 짧은 제목은 러닝 헤더에 표시됩니다
  short-title: none,
  // 짧은 인용은 러닝 헤더에 표시되며, auto로 설정하면 저자와 연도를 APA 형식으로 표시합니다.
  short-citation: auto,
  // 발표 장소는 푸터에 표시됩니다
  venue: none,
  // 페이지 오른쪽 상단에 표시되는 이미지 경로. 콘텐츠일 수도 있습니다.
  logo: none,
  // 첫 페이지 헤더에 표시되는 DOI 링크. DOI만 입력하세요, 예: `10.10123/123456`, URL이 아닙니다
  doi: none,
  // 기본값: heading-numbering: "1.a.i",
  heading-numbering: none,
  // 첫 페이지에 오픈 액세스 배지를 표시하고 오픈 사이언스를 지원합니다. 기본값은 true입니다.
  open-access: true,
  // 초록 뒤에 표시할 키워드 목록
  keywords: (),
  // 콘텐츠의 "종류", 예: "Original Research", 첫 페이지 여백 콘텐츠의 제목으로 표시됩니다.
  kind: none,
  // 첫 페이지 여백에 넣을 콘텐츠
  // `title`과 `content`가 있는 딕셔너리 목록이어야 합니다
  margin: (),
  paper-size: "a4",
  // 문서 테마 색상, nord theme Frost: #8fbcbb, #88c0d0, #81a1c1, #5e81ac
  theme: rgb("#8fbcbb"),
  // 발행 날짜, 예를 들어 프리프린트를 아카이브 서버에 게시할 때.
  // 날짜를 숨기려면 `none`으로 설정하세요. `title`과 `date`가 있는 딕셔너리 목록을 제공할 수도 있습니다.
  date: datetime.today(),
  // 자유롭게 변경하세요. 이 폰트는 전체 문서에 적용됩니다
  font-face: "Noto Sans KR",
  // 외부 작품을 인용하려는 경우 참고문헌 파일 경로
  bibliography-file: none,
  bibliography-style: "apa",
  // 논문의 내용
  body
) = {

  /* 로고 */
  let orcidSvg = ```<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 24 24"> <path fill="#AECD54" d="M21.8,12c0,5.4-4.4,9.8-9.8,9.8S2.2,17.4,2.2,12S6.6,2.2,12,2.2S21.8,6.6,21.8,12z M8.2,5.8c-0.4,0-0.8,0.3-0.8,0.8s0.3,0.8,0.8,0.8S9,7,9,6.6S8.7,5.8,8.2,5.8z M10.5,15.4h1.2v-6c0,0-0.5,0,1.8,0s3.3,1.4,3.3,3s-1.5,3-3.3,3s-1.9,0-1.9,0H10.5v1.1H9V8.3H7.7v8.2h2.9c0,0-0.3,0,3,0s4.5-2.2,4.5-4.1s-1.2-4.1-4.3-4.1s-3.2,0-3.2,0L10.5,15.4z"/></svg>```.text

  let spacer = text(fill: gray)[#h(8pt) | #h(8pt)]

  let dates;
  if (type(date) == datetime) {
    dates = ((title: "Published", date: date),)
  }else if (type(date) == dictionary) {
    dates = (date,)
  } else {
    dates = date
  }
  date = dates.at(0).date

  // 짧은 인용 생성, 예: Cockett et al., 2023
  let year = if (date != none) { ", " + date.display("[year]") }
  if (short-citation == auto and authors.len() == 1) {
    short-citation = authors.at(0).name.split(" ").last() + year
  } else if (short-citation == auto and authors.len() == 2) {
    short-citation = authors.at(0).name.split(" ").last() + " & " + authors.at(1).name.split(" ").last() + year
  } else if (short-citation == auto and authors.len() > 2) {
    short-citation = authors.at(0).name.split(" ").last() + " " + emph("et al.") + year
  }

  // 문서 메타데이터 설정
  set document(title: title, author: authors.map(author => author.name))

  show link: it => [#text(fill: theme)[#it]]
  show ref: it => [#text(fill: theme)[#it]]

  set page(
    paper-size,
    margin: (left: 25%),
    header: context {
      let loc = here()
      if(loc.page() == 1) {
        let headers = (
          if (open-access) {smallcaps[Open Access]},
          if (doi != none) { link("https://doi.org/" + doi, "https://doi.org/" + doi)}
        )
        align(left, text(size: 8pt, fill: gray, headers.filter(header => header != none).join(spacer)))
      } else {
        align(right, text(size: 8pt, fill: gray.darken(50%),
          (short-title, short-citation).join(spacer)
        ))
      }
    },
    footer: block(
      width: 100%,
      stroke: (top: 1pt + gray),
      inset: (top: 8pt, right: 2pt),
      [
        #grid(columns: (75%, 25%),
          align(left, text(size: 9pt, fill: gray.darken(50%),
              (
                if(venue != none) {emph(venue)},
                if(date != none) {date.display("[month repr:long] [day], [year]")}
              ).filter(t => t != none).join(spacer)
          )),
          align(right)[
            #context {
              text(
                size: 9pt, fill: gray.darken(50%)
              )[
                #counter(page).display() of #counter(page).final().first()
              ]
            }
          ]
        )
      ]
    )
  )

  // 본문 폰트 설정
  set text(font: font-face, size: 10pt)
  // 수식 번호 매기기 및 간격 설정
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 1em)

  // 목록 설정
  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt)

  // 제목 설정
  set heading(numbering: heading-numbering)
  show heading: it => context {
    // 제목 카운터의 최종 번호 찾기
    let levels = counter(heading).at(here())
    set text(10pt, weight: 400)
    if it.level == 1 [
      // 1단계 제목은 가운데 정렬된 작은 대문자입니다.
      // 감사의 글 섹션은 번호를 매기지 않습니다.
      #let is-ack = it.body in ([Acknowledgment], [Acknowledgement])
      // #set align(center)
      #set text(if is-ack { 10pt } else { 12pt })
      #show: smallcaps
      #v(20pt, weak: true)
      #if it.numbering != none and not is-ack {
        numbering(heading-numbering, ..levels)
        [.]
        h(7pt, weak: true)
      }
      #it.body
      #v(13.75pt, weak: true)
    ] else if it.level == 2 [
      // 2단계 제목은 런인 형태입니다.
      #set par(first-line-indent: 0pt)
      #set text(style: "italic")
      #v(10pt, weak: true)
      #if it.numbering != none {
        numbering(heading-numbering, ..levels)
        [.]
        h(7pt, weak: true)
      }
      #it.body
      #v(10pt, weak: true)
    ] else [
      // 3단계 제목도 런인 형태이지만 다릅니다.
      #if it.level == 3 {
        numbering(heading-numbering, ..levels)
        [. ]
      }
      _#(it.body):_
    ]
  }


  if (logo != none) {
    place(
      top,
      dx: -33%,
      float: false,
      box(
        width: 27%,
        {
          if (type(logo) == content) {
            logo
          } else {
            image(logo, width: 42%)
          }
        },
      ),
    )
  }


  // 제목과 부제목
  box(inset: (bottom: 2pt), text(17pt, weight: "bold", fill: theme, title))
  if subtitle != none {
    parbreak()
    box(text(14pt, fill: gray.darken(30%), subtitle))
  }
  // 저자와 소속
  if authors.len() > 0 {
    box(inset: (y: 10pt), {
      authors.map(author => {
        text(11pt, weight: "semibold", author.name)
        h(1pt)
        if "affiliations" in author {
          super(author.affiliations)
        }
        if "orcid" in author {
          link("https://orcid.org/" + author.orcid)[#box(height: 1.1em, baseline: 13.5%)[#image(bytes(orcidSvg))]]
        }
      }).join(", ", last: ", and ")
    })
  }
  if affiliations.len() > 0 {
    box(inset: (bottom: 10pt), {
      affiliations.map(affiliation => {
        super(affiliation.id)
        h(1pt)
        affiliation.name
      }).join(", ")
    })
  }


  place(
    left + bottom,
    dx: -33%,
    dy: -10pt,
    box(width: 27%, {
      if (kind != none) {
        set par(spacing: 0em)
        text(11pt, fill: theme, weight: "semibold", smallcaps(kind))
        parbreak()
      }
      if (dates != none) {
        let formatted-dates

        grid(columns: (40%, 60%), gutter: 7pt,
          ..dates.zip(range(dates.len())).map((formatted-dates) => {
            let d = formatted-dates.at(0);
            let i = formatted-dates.at(1);
            let weight = "light"
            if (i == 0) {
              weight = "bold"
            }
            return (
              text(size: 7pt, fill: theme, weight: weight, d.title),
              text(size: 7pt, d.date.display("[month repr:short] [day], [year]"))
            )
          }).flatten()
        )
      }
      v(2em)
      grid(columns: 1, gutter: 2em, ..margin.map(side => {
        text(size: 7pt, {
          if ("title" in side) {
            text(fill: theme, weight: "bold", side.title)
            [\ ]
          }
          set enum(indent: 0.1em, body-indent: 0.25em)
          set list(indent: 0.1em, body-indent: 0.25em)
          side.content
        })
      }))
    }),
  )


  let abstracts
  if (type(abstract) == content) {
    abstracts = (title: "Abstract", content: abstract)
  } else {
    abstracts = abstract
  }

  box(inset: (top: 16pt, bottom: 16pt), stroke: (top: 1pt + gray, bottom: 1pt + gray), {

    abstracts.map(abs => {
      set par(justify: true)
      text(fill: theme, weight: "semibold", size: 9pt, abs.title)
      parbreak()
      abs.content
    }).join(parbreak())
  })
  if (keywords.len() > 0) {
    text(size: 9pt, {
      text(fill: theme, weight: "semibold", "Keywords")
      h(8pt)
      keywords.join(", ")
    })
  }
  v(10pt)

  set par(spacing: 1.5em)

  // 논문 내용 표시
  body

  if (bibliography-file != none) {
    show bibliography: set text(8pt)
    bibliography(bibliography-file, title: text(12pt, "References"), style: bibliography-style)
  }
}