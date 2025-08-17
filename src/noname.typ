#import "./templates/conf.typ": template

#show: template.with(
  title: "This is private constructive Peer Review Comments",
  subtitle: "A Tutorial on Finite Volume",
  short-title: "Finite Volume Tutorial",
  venue: [ar#text(fill: blue.darken(20%))[X]iv],
  // This is relative to the template file
  // When importing normally, you should be able to use it relative to this file.
  // logo: "examples/pixels/files/logo.png",
  doi: "10.1190/XXXXXXX",
  // You can make all dates optional, however, `date` is by default `datetime.today()`
  date: (
    (title: "Published", date: datetime(year: 2023, month: 08, day: 21)),
    (title: "Accepted", date: datetime(year: 2022, month: 12, day: 10)),
    (title: "Submitted", date: datetime(year: 2022, month: 12, day: 10)),
  ),
  theme: blue.darken(30%),
  authors: (
    (
      name: "Taeyoon kim",
      orcid: "0009-0006-9227-1167",
      email: "deepthought@postech.ac.kr",
      affiliations: "1,2"
    ),
    (
      name: "Lindsey Heagy",
      orcid: "0000-0002-1551-5926",
      affiliations: "1",
    ),
    (
      name: "Douglas Oldenburg",
      orcid: "0000-0002-4327-2124",
      affiliations: "1"
    ),
  ),
  kind: "Notebook Tutorial",
  affiliations: (
   (id: "1", name: "University of British Columbia"),
   (id: "2", name: "Curvenote Inc."),
  ),
  abstract: (
    (title: "Abstract", content: lorem(100)),
    (title: "Plain Language Summary", content: lorem(25)),
  ),
  keywords: ("Finite Volume", "Tutorial", "Reproducible Research"),
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
        Rowan Cockett\
        #link("mailto:rowan@curvenote.com")[rowan\@curvenote.com]
      ],
    ),
    (
      title: "Data Availability",
      content: [
        Associated notebooks are available on #link("https://github.com/simpeg/tle-finitevolume")[GitHub] and can be run online with #link("http://mybinder.org/repo/simpeg/tle-finitevolume")[MyBinder].
      ],
    ),
    (
      title: "Funding",
      content: [
        Funding was provided by the Vanier Award to each of Cockett and Heagy.
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

= DC Resistivity <dc-resistivity>

#lorem(200)

// #figure(
//   image("files/dc-setup.png", width: 60%),
//   caption: [Setup of a DC resistivity survey.],
// ) <dc-setup>

// You can put this after the content that fits on the first page to set the margins back to full-width
#set page(margin: auto)

The equations for DC resistivity are derived in. Conservation of charge (which can be derived by taking the divergence of Ampere's law at steady state) connects the divergence of the current density everywhere in space to the source term which consists of two point sources, one positive and one negative.

The flow of current sets up electric fields according to Ohm's law, which relates current density to electric fields through the electrical conductivity. From Faraday's law for steady state fields, we can describe the electric field in terms of a scalar potential, $phi$, which we sample at potential electrodes to obtain data in the form of potential differences.

// #figure(
//   image("files/dc-eqns.png", width: 100%),
//   caption: [Derivation of the DC resistivity equations.],
// ) <dc-eqns>

To set up a solvable system of equations, we need the same number of unknowns as equations, in this case two unknowns (one scalar, $phi$, and one vector $arrow(j)$) and two first-order equations (one scalar, one vector).

In this tutorial, we walk through setting up these first order equations in finite volume in three steps: (1) defining where the variables live on the mesh; (2) looking at a single cell to define the discrete divergence and the weak formulation; and (3) moving from a cell based view to the entire mesh to construct and solve the resulting matrix system. The notebooks included with this tutorial leverage the #link("http://simpeg.xyz/")[SimPEG] package, which extends the methods discussed here to various mesh types.

= Where do things live? <where-do-things-live>

To bring our continuous equations into the computer, we need to discretize the earth and represent it using a finite(!) set of numbers. In this tutorial we will explain the discretization in 2D and generalize to 3D in the notebooks. A 2D (or 3D!) mesh is used to divide up space, and we can represent functions (fields, parameters, etc.) on this mesh at a few discrete places: the nodes, edges, faces, or cell centers. For consistency between 2D and 3D we refer to faces having area and cells having volume, regardless of their dimensionality. Nodes and cell centers naturally hold scalar quantities while edges and faces have implied directionality and therefore naturally describe vectors. The conductivity, $sigma$, changes as a function of space, and is likely to have discontinuities (e.g. if we cross a geologic boundary). As such, we will represent the conductivity as a constant over each cell, and discretize it at the center of the cell. The electrical current density, $arrow(j)$, will be continuous across conductivity interfaces, and therefore, we will represent it on the faces of each cell. Remember that $arrow(j)$ is a vector; the direction of it is implied by the mesh definition (i.e. in $x$, $y$ or $z$), so we can store the array $bold(j)$ as _scalars_ that live on the face and inherit the face's normal. When $arrow(j)$ is defined on the faces of a cell the potential, $phi$, will be put on the cell centers (since $arrow(j)$ is related to $phi$ through spatial derivatives, it allows us to approximate centered derivatives leading to a staggered, second-order discretization). Once we have the functions placed on our mesh, we look at a single cell to discretize each first order equation. For simplicity in this tutorial we will choose to have all of the faces of our mesh be aligned with our spatial axes ($x$, $y$ or $z$), the extension to curvilinear meshes will be presented in the supporting notebooks.


// If you are using full-width pages, you must take care of your own bibliography.
// Otherwise it will be on a separate page
#{
  show bibliography: set text(8pt)
  bibliography("noname.bib", title: text(10pt, "References"), style: "apa")
}