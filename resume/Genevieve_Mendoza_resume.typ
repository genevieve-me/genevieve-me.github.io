#import "lib_resume.typ": *

#let name = "Genevieve Mendoza"

#show: resume.with(
  author: name,
  location: "New York, NY, USA",
  email: "me@genevievemendoza.com",
  github: "github.com/genevieve-me",
  linkedin: "linkedin.com/in/genevievemendoza",
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
  gpa: "3.93 / 4.0",
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
- Improved core API response speeds by 90x through SQL query tuning and trimmed over 30\% of yearly cloud spend by eliminating cloud inefficiencies
- Shipped a full-stack Rust and React custom client application that distills hundreds of thousands of weekly signals into curated insights that were previously infeasible to surface
- Trained BERT-based language models for document classification and implemented full-stack RAG pipeline for new recommendation engine
- Engineered CI pipelines for all projects from scratch, enabling automated continuous deployment and reducing developer toil to nearly zero
- Architected cloud strategy and unified infrastructure on AWS, migrating all services to containerized deployments managed entirely with IaC
- Brought adoption of full-stack observability with OpenTelemetry from 0% to 95%, uncovering bugs and cutting median downtime by over half
- Proactively eliminated security risks by identifying and mitigating leaked credentials with secret scanning and implementing role-based access controls
- Improved developer experience by documenting legacy cronjobs and consolidating 40% of unmaintained lines of code into the primary data processing service
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
- #strong[Statistics & ML:] SVMs and MLPs, transformers (BERT), embeddings, neural networks, naive Bayes, NLP
- #strong[Programming Languages:] Rust, Python, SQL (Postgres/sqlite), R, Nix, HTML/CSS, basic React, bash
- #strong[Technologies:] Python data stack (PyTorch, Polars, Pydantic, Sentence Transformers), Rust ecosystem (sqlx, tokio), Grafana, GitLab CI/CD
- #strong[Linux & Containers:] GNU tools, systemd, Docker/Podman, network namespaces, cgroups, nftables, iproute2, gdb, perf 
- #strong[AWS Stack:] ECS clusters; serverless architectures with Lambda, EventBridge, and SQS; IAM and AWS Organizations, Terraform/OpenTofu, 
- #strong[Workflows:] Collaborated in an Agile workflow tracking epics and story points with GitLab and Trello (Kanban)
