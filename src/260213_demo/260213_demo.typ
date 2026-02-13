#import "../templates/conf.typ": template

#show: template.with(
  title: "Demo",
  subtitle: "PDF_Demo",
  short-title: "Demo",
  // venue: [Venue Name],
  // logo: "path/to/logo.png",
  // doi: "10.1234/example",
  date: datetime(year: 2026, month: 2, day: 13),
  // theme: rgb("#5e81ac"),
  authors: (
    (
      name: "TaeyoonKim",
      // orcid: "0000-0000-0000-0000",
      // email: "email@example.com",
      // affiliations: "1"
    ),
  ),
  // affiliations: (
  //   (id: "1", name: "Affiliation Name"),
  // ),
  abstract: (
    (title: "Abstract", content: [
      Enter your abstract here...
    ]),
  ),
  keywords: ("Key1", "Key2"),
  // open-access: true,
  // kind: "Article",
  // margin: (
  //   (
  //     title: "Key Points",
  //     content: [
  //       - Point 1
  //       - Point 2
  //     ],
  //   ),
  // ),
)

= Introduction <introduction>

Write your introduction here.

= Conclusion <conclusion>

Write your conclusion here.
