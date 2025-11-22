#import "lib_resume.typ": *

#let name = "Genevieve Mendoza"

#show: resume.with(
  author: name,
  location: "New York, NY, USA",
  email: "me@genevievemendoza.com",
  github: "github.com/genevieve-me",
  linkedin: "linkedin.com/in/genevieve-me",
  phone: "+1 (201) 887-2611",
  personal-site: "genevievemendoza.com",
  accent-color: "#004f90",
  font: "Source Sans 3",
  paper: "us-letter",
  author-position: center,
  personal-info-position: center,
)

== Education

#edu(
  institution: "Washington University in St. Louis",
  location: "St. Louis, MO",
  dates: dates-helper(start-date: "Aug 2019", end-date: "May 2023"),
  degree: "B.A., Majors in Statistics & Economics",
  gpa: "3.91 / 4.0",
)
- High Honors and Dean's List; leadership roles with ArchHacks/HackWashU, Association for Women in Math, and Fossil Free
- Teaching assistant for Data Structures & Algorithms and Analysis courses

== Work Experience

#work(
  title: "Data Engineer",
  location: "Remote (EU)",
  company: "The Syllabus",
  dates: dates-helper(start-date: "2023", end-date: "Present"),
)
- Optimized core API response speeds by 90x through SQL query tuning and trimmed over \$1,800 in yearly cloud spend by eliminating infrastructure inefficiencies
- Trained BERT-based language models for document classification and implemented vector-search RAG for a new recommendation engine and internal data pipeline
- Engineered CI pipelines for all projects from scratch, enabling automated continuous deployment and reducing developer toil to nearly zero
- Architected cloud strategy and unified infrastructure on AWS, migrating all services to containerized deployments managed entirely with IaC
- Spearheaded adoption of full-stack observability with OpenTelemetry, uncovering hidden bugs and delivering high-level operational insights
- Proactively eliminated security risks by identifying and mitigating leaked credentials with secret scanning and implementing role-based access controls
- Improved developer experience by documenting legacy cronjobs and consolidating functionality into the primary data processing service
- Collaborated on database schema redesign and migration to simplify the codebase and improve user load times

#work(
  title: "Assistant Editor, Black 1968",
  location: "St. Louis, MO",
  company: "WUSTL Department of History / Palgrave Macmillan",
  dates: dates-helper(start-date: "2022", end-date: "2023"),
)
- Partnered with a multi-university research team on an interdisciplinary publication covering 1960s social history
- Improved clarity of technical writing, organized content and citations, and drove follow-ups on research tasks

#work(
  title: "Admissions Staff and Summer Intern",
  location: "St. Louis, MO",
  company: "Graduate Programs, Olin Business School",
  dates: dates-helper(start-date: "2019", end-date: "2020"),
)
- Drove data-informed decisions by preparing BI visualizations, contributing to centralized data warehousing, and automating lead-generation scraping

== Skills

- #strong[Languages:] English (fluent), French (proficient), Spanish (conversant)
- #strong[Statistics & ML:] SVMs and MLPs, transformers (BERT), embeddings, neural networks, naive Bayes
- #strong[Programming Languages:] Python, SQL (Postgres/sqlite), R, Nix, HTML/CSS, basic Rust
- #strong[Technologies:] Python data stack (pytorch, polars, pydantic), AWS ECS/RDS/Lambda, Terraform/OpenTofu, Grafana, GitLab CI/CD
- #strong[Linux & Containers:] GNU tools, systemd, user and network namespaces, cgroups, nftables, iproute2
