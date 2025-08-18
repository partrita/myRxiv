#import "./templates/conf.typ": template

#show: template.with(
  title: "This is private journal like article",
  subtitle: "It's a Beautiful typst templates",
  short-title: "First journal like article",
  venue: [my#text(fill: rgb("#bf616a"))[R]xiv],
  // 로고의 위치는 템플릿 파일에 상대적입니다
  //logo: "logo_extend.png",
  doi: "10.1190/XXXXXXX",
  // 모든 날짜를 선택사항으로 만들 수 있지만, `date`는 기본적으로 `datetime.today()`입니다
  date: (
    // (title: "Published", date: datetime(year: 2025, month: 08, day: 18)),
    // (title: "Accepted", date: datetime(year: 2025, month: 08, day: 17)),
    (title: "Submitted", date: datetime(year: 2025, month: 08, day: 16)),
  ),
  theme: rgb("#5e81ac"),
  authors: (
    (
      name: "Taeyoon kim",
      orcid: "0009-0006-9227-1167",
      email: "deepthought@postech.ac.kr",
      affiliations: "1,2"
    ),
    (
      name: "Kimberly R. Keyser",
      orcid: "0000-0002-1551-5926",
      affiliations: "1",
    ),
    (
      name: "James N. Manhart",
      orcid: "0000-0002-4327-2124",
      affiliations: "1"
    ),
  ),
  kind: "Typst Tutorial",
  affiliations: (
   (id: "1", name: "Pro Star"),
   (id: "2", name: "Reliable Guidance"),
  ),
  abstract: (
    (title: "Abstract", content: lorem(100)),
    (title: "Plain Language Summary", content: lorem(25)),
  ),
  keywords: ("Mozilla", "Tutorial", "Reproducible Research"),
  open-access: true,
  margin: (
    (
      title: "Key Points",
      content: [
        - #lorem(10)
        - #lorem(5)
        - #lorem(7)
      ],
    ),
    (
      title: "Correspondence to",
      content: [
        Taeyoon kim\
        #link("mailto:deepthought@postech.ac.kr")[deepthought\@postech.ac.kr]
      ],
    ),
    (
      title: "Data Availability",
      content: [
        Associated notebooks are available on #link("https://github.com/partrita/myRxiv")[GitHub].
      ],
    ),
    (
      title: "Funding",
      content: [
        Funding was provided by me.
      ],
    ),
    (
      title: "Competing Interests",
      content: [
        The authors declare no competing interests.
      ],
    ),
  ),
)

= Introduction <introduction>

#lorem(200)


// 첫 페이지에 맞는 내용 뒤에 이것을 넣어서 여백을 전체 너비로 다시 설정할 수 있습니다

#set page(margin: auto)

#lorem(200)

#figure(
   image("files/Scikit_learn_logo.png", width: 50%),
   caption: [Just random logo.],
 ) <dc-setup>

To set up a solvable system of equations, we need the same number of unknowns as equations, in this case two unknowns (one scalar, $phi$, and one vector $arrow(j)$) and two first-order equations (one scalar, one vector).

In this tutorial, we walk through setting up these first order equations in finite volume in three steps: (1) defining where the variables live on the mesh; (2) looking at a single cell to define the discrete divergence and the weak formulation; and (3) moving from a cell based view to the entire mesh to construct and solve the resulting matrix system. The notebooks included with this tutorial leverage the #link("http://simpeg.xyz/")[SimPEG] package, which extends the methods discussed here to various mesh types.

= Methodology <methodology>

To bring our continuous equations into the computer, we need to discretize the earth and represent it using a finite(!) set of numbers. In this tutorial we will explain the discretization in 2D and generalize to 3D in the notebooks. A 2D (or 3D!) mesh is used to divide up space, and we can represent functions (fields, parameters, etc.) on this mesh at a few discrete places: the nodes, edges, faces, or cell centers. For consistency between 2D and 3D we refer to faces having area and cells having volume, regardless of their dimensionality. Nodes and cell centers naturally hold scalar quantities while edges and faces have implied directionality and therefore naturally describe vectors. The conductivity, $sigma$, changes as a function of space, and is likely to have discontinuities (e.g. if we cross a geologic boundary). As such, we will represent the conductivity as a constant over each cell, and discretize it at the center of the cell. The electrical current density, $arrow(j)$, will be continuous across conductivity interfaces, and therefore, we will represent it on the faces of each cell. Remember that $arrow(j)$ is a vector; the direction of it is implied by the mesh definition (i.e. in $x$, $y$ or $z$), so we can store the array $bold(j)$ as _scalars_ that live on the face and inherit the face's normal. When $arrow(j)$ is defined on the faces of a cell the potential, $phi$, will be put on the cell centers (since $arrow(j)$ is related to $phi$ through spatial derivatives, it allows us to approximate centered derivatives leading to a staggered, second-order discretization). Once we have the functions placed on our mesh, we look at a single cell to discretize each first order equation. For simplicity in this tutorial we will choose to have all of the faces of our mesh be aligned with our spatial axes ($x$, $y$ or $z$), the extension to curvilinear meshes will be presented in the supporting notebooks.
@Cockett_2016

= Results and Conclusion <results-and-discussion>

#lorem(400)

= Discussion <discussion>

#lorem(400)



// 전체 너비 페이지를 사용하는 경우, 참고문헌을 직접 관리해야 합니다. 그렇지 않으면 별도 페이지에 표시됩니다
#{
  show bibliography: set text(8pt)
  bibliography("250818_noname.bib", title: text(12pt, "References"), style: "apa")
}