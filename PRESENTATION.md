# 🎬 Looker Hub & Spoke Live Demo: Master 8-Slide Presenter Deck

> **Instance Base URL:** `https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app`  
> **Looker Admin Users:** [Open Admin Users](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/admin/users)  
> **Structure:** 8 Interactive Demo Slides with Direct Code & Explore Links

---

## 📑 Slide Deck Navigation

1. [**Slide 1: The Central Hub — Governed Single Source of Truth**](#slide-1-the-central-hub--governed-single-source-of-truth)
2. [**Slide 2: The Finance Spoke — Project Import & Manifest Dependency**](#slide-2-the-finance-spoke--project-import--manifest-dependency)
3. [**Slide 3: Departmental Modeling — Refinements vs. Extensions**](#slide-3-departmental-modeling--refinements-vs-extensions)
4. [**Slide 4: Finance Explores in Action — GAAP Accounting & Audits**](#slide-4-finance-explores-in-action--gaap-accounting--audits)
5. [**Slide 5: The Marketing Spoke — Bespoke Ingestion (Events & Clickstream)**](#slide-5-the-marketing-spoke--bespoke-ingestion-events--clickstream)
6. [**Slide 6: Marketing in Action — Refined Audiences & PII Masking**](#slide-6-marketing-in-action--refined-audiences--pii-masking)
7. [**Slide 7: Enterprise Governance — Live Persona Switching (Sudo Walkthrough)**](#slide-7-enterprise-governance--live-persona-switching-sudo-walkthrough)
8. [**Slide 8: Executive Summary & Live Links Master Reference**](#slide-8-executive-summary--live-links-master-reference)

---

# Slide 1: The Central Hub — Governed Single Source of Truth

### 🎯 Slide Purpose
Introduce the core foundation: a clean, central Hub repository that defines enterprise Single Source of Truth (SSOT) logic, explicit primary keys, PII access grants, and generic explore topology templates.

### 🔗 Direct Looker Code Links
* 📄 **Hub Manifest:** [`manifest.lkml`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/projects/thelook-antigravity/files/manifest.lkml) &rarr; Declares `project_name: "thelook-antigravity"`
* 📄 **Governed Core View:** [`thelook_views/users.view.lkml`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/projects/thelook-antigravity/files/thelook_views/users.view.lkml) &rarr; Contains primary keys & central `pii_data` access grants.
* 📄 **Governed Sales View:** [`thelook_views/order_items.view.lkml`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/projects/thelook-antigravity/files/thelook_views/order_items.view.lkml) &rarr; Single Source of Truth sales measures.
* 📄 **Generic Explore Topology:** [`explores/thelook_hub.explore.lkml`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/projects/thelook-antigravity/files/explores/thelook_hub.explore.lkml) &rarr; Standard joins, `hidden: yes` by default.

### 💡 Presenter Talking Points
* *"Everything starts in the Central Hub (`thelook-antigravity`). This project is strictly controlled by central data architects."*
* *"Notice that generic explores in [`thelook_hub.explore.lkml`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/projects/thelook-antigravity/files/explores/thelook_hub.explore.lkml) have `hidden: yes` by default. They serve as reusable topology blueprints so spokes never inherit unneeded explores automatically."*
* *"Universal policies — like requiring the `can_see_pii` attribute for customer emails — are defined once here in the Hub and automatically protect every departmental downstream spoke."*

---

# Slide 2: The Finance Spoke — Project Import & Manifest Dependency

### 🎯 Slide Purpose
Show how a departmental team builds their own standalone repository that imports the Central Hub without any code duplication.

### 🔗 Direct Looker Code Links
* 📄 **Finance Manifest:** [`manifest.lkml`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/projects/thelook-finance-spoke/files/manifest.lkml) &rarr; Declares `local_dependency: { project: "thelook-antigravity" }`
* 📄 **Finance Model File:** [`models/thelook_finance.model.lkml`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/projects/thelook-finance-spoke/files/models/thelook_finance.model.lkml) &rarr; Imports Hub views & selectively unhides Finance explores.

### 📊 Code Mechanics Breakdown
```lookml
# manifest.lkml in thelook-finance-spoke
project_name: "thelook_finance"

local_dependency: {
  project: "thelook-antigravity" # Imports the Central Hub as a read-only library
}
```

```lookml
# models/thelook_finance.model.lkml
include: "//thelook-antigravity/thelook_views/**/*.view.lkml"
include: "//thelook-antigravity/explores/thelook_hub.explore.lkml"
include: "/views/*.view.lkml"

# Finance selectively unhides ONLY the explores they care about:
explore: +order_items {
  hidden: no
  label: "Finance: Revenue & Tax Accounting"
  group_label: "Finance Spoke"
}
```

### 💡 Presenter Talking Points
* *"The Finance team operates in their own Git repository (`thelook-finance-spoke`)."*
* *"By declaring `local_dependency` in [`manifest.lkml`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/projects/thelook-finance-spoke/files/manifest.lkml), they import the Hub's governed views as a read-only library."*
* *"Finance has full autonomy over their release cycle, but they cannot accidentally mutate or break the upstream Hub."*

---

# Slide 3: Departmental Modeling — Refinements vs. Extensions

### 🎯 Slide Purpose
Answer the fundamental modeling question: **"When do we use Refinements (`+view`) vs. Extensions (`extends`)?"**

### 🔗 Direct Looker Code Links
* 📄 **Finance Refinement View:** [`views/order_items_rfn.view.lkml`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/projects/thelook-finance-spoke/files/views/order_items_rfn.view.lkml) &rarr; Universal in-place augmentation.
* 📄 **Finance Extension View:** [`views/order_items_ext.view.lkml`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/projects/thelook-finance-spoke/files/views/order_items_ext.view.lkml) &rarr; Distinct standalone variant.

### 📊 Visual Decision Matrix

```
┌───────────────────────────────────────────────────────────┬───────────────────────────────────────────────────────────┐
│              1. REFINEMENTS (view: +order_items)          │            2. EXTENSIONS (view: order_items_ext)          │
├───────────────────────────────────────────────────────────┼───────────────────────────────────────────────────────────┤
│ • In-place universal modification                         │ • Creates a new, distinct standalone view                 │
│ • Automatically enriches all existing queries & explores  │ • Prevents field collision & isolates custom logic        │
│ • Example: Adding GAAP `net_revenue` & `estimated_tax`    │ • Example: Filtered high-value audit thresholds (> $500)  │
└───────────────────────────────────────────────────────────┴───────────────────────────────────────────────────────────┘
```

### 💡 Code Comparison
```lookml
# REFINEMENT (+order_items): Enriches existing view everywhere in Finance
view: +order_items {
  measure: total_net_revenue {
    type: sum
    sql: ${sale_price} - ${inventory_items.cost} ;;
    value_format_name: usd
  }
}

# EXTENSION (order_items_ext): Standalone specialized view for Auditing
view: order_items_ext {
  extends: [order_items]
  dimension: audit_flag {
    type: yesno
    sql: ${sale_price} > 500 ;;
  }
}
```

---

# Slide 4: Finance Explores in Action — GAAP Accounting & Audits

### 🎯 Slide Purpose
Open the live Finance Explores and show how Refinements, Extensions, and PII access unmasking behave in real time.

### 🔗 Direct Explore Links for Live Demo
* 📊 **Finance Accounting:** [Open `Finance: Revenue & Tax Accounting`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_finance/order_items)
* 📊 **Finance Audits:** [Open `Finance: High-Value Transaction Audits`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_finance/finance_high_value_audits)

### 🖥️ Live Action & Screen Steps
1. Open [**`Finance: Revenue & Tax Accounting`**](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_finance/order_items).
2. **Select Fields:**
   - `Order Items -> Status`
   - `Order Items -> Total Net Revenue` *(Custom Refinement measure!)*
   - `Order Items -> Total Estimated Tax` *(Custom Refinement measure!)*
   - `Users -> Email` *(Unmasked for Finance Auditors!)*
3. Click **Run**.
4. Open [**`Finance: High-Value Transaction Audits`**](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_finance/finance_high_value_audits) &rarr; Show the dedicated audit explore built using `order_items_ext`.

### 💡 Presenter Talking Points
* *"Here is the Finance Spoke in action. Notice that `Total Net Revenue` and `Total Estimated Tax` are available seamlessly alongside central Hub fields."*
* *"Because we are viewing this as an authorized auditor, the `Email` field is unmasked and queryable for audit trail verification."*

---

# Slide 5: The Marketing Spoke — Bespoke Ingestion (Events & Clickstream)

### 🎯 Slide Purpose
Demonstrate the killer enterprise capability: **Spoke-Exclusive Data Ingestion**, where high-volume raw tables are ingested directly into a spoke without polluting the Hub or exposing event logs to other departments.

### 🔗 Direct Looker Code Links
* 📄 **Marketing Manifest:** [`manifest.lkml`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/projects/thelook-marketing-spoke/files/manifest.lkml)
* 📄 **Bespoke Clickstream View:** [`views/events.view.lkml`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/projects/thelook-marketing-spoke/files/views/events.view.lkml)
* 📄 **Marketing Model File:** [`models/thelook_marketing.model.lkml`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/projects/thelook-marketing-spoke/files/models/thelook_marketing.model.lkml)

### 💡 Highlight Quote for Presenter
> *"In a traditional monolithic setup, high-volume clickstream logs would pollute the central repository and overwhelm unrelated departments like Finance.*  
> *With **Hub & Spoke**, Marketing can ingest raw clickstream tables (`events`) directly into their Spoke, join them seamlessly with governed central entities (`users` from the Hub), while keeping the Hub clean and Finance completely insulated from clickstream noise."*

### 📊 Code Mechanics Breakdown
```lookml
# models/thelook_marketing.model.lkml
explore: events {
  label: "Marketing: Web Traffic & Event Clickstream"
  group_label: "Marketing Spoke"
  description: "Exclusive departmental clickstream data ingested directly into the Marketing Spoke"

  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${users.id} = ${events.user_id} ;; # Seamlessly joins to Governed Central Hub View!
  }
}
```

---

# Slide 6: Marketing in Action — Refined Audiences & PII Masking

### 🎯 Slide Purpose
Execute the live Marketing explores and demonstrate how custom channel attribution works while central PII masking is strictly enforced.

### 🔗 Direct Explore Links for Live Demo
* 📊 **Web Clickstream:** [Open `Marketing: Web Traffic & Event Clickstream`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_marketing/events)
* 📊 **Customer Audiences:** [Open `Marketing: Customer Acquisition & Audiences`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_marketing/users)
* 📊 **Cohort Analysis:** [Open `Marketing: Cohort Performance Analysis`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_marketing/marketing_campaign_cohorts)

### 🖥️ Live Action & Screen Steps
1. Open [**`Marketing: Web Traffic & Event Clickstream`**](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_marketing/events):
   - Select `Events -> Event Type`, `Events -> Count`, and `Users -> State` &rarr; Click **Run**.
2. Open [**`Marketing: Customer Acquisition & Audiences`**](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_marketing/users):
   - 🟢 **Show Custom Refinement:** Select `Users -> Marketing Channel Group` (`Search Engine`, `Paid Social/Ads`, `Direct / Organic`).
   - 🔒 **Show Central PII Protection:** Notice that the `Email` dimension is **completely hidden** because marketing analysts have `can_see_pii = No`.

### 💡 Presenter Talking Points
* *"Look at `Marketing Channel Group`: Marketing created this dimension in their own spoke to bucket channels for attribution."*
* *"Notice that even though Marketing owns this Spoke, they could not bypass the central Hub's PII security rule — customer emails remain protected."*

---

# Slide 7: Enterprise Governance — Live Persona Switching (Sudo Walkthrough)

### 🎯 Slide Purpose
Demonstrate dynamic menu adaptation and multi-tenant security live in the Looker UI using the 1-command persona switcher.

### 🎮 Persona Switcher Control Matrix
```
                               ┌─────────────────────────────────┐
                               │   python3 scripts/set_persona   │
                               └────────────────┬────────────────┘
                                                │
                 ┌──────────────────────────────┼──────────────────────────────┐
                 ▼                              ▼                              ▼
            [marketing]                     [finance]                     [executive]
         Role 48 (Marketing)             Role 49 (Finance)             Role 50 (Executive)
         `can_see_pii = No`             `can_see_pii = Yes`            `can_see_pii = No`
```

### 🖥️ Live Sudo Demonstration Sequence
1. **Marketing View:**
   - In terminal: `python3 scripts/set_persona.py marketing`
   - In Looker: Go to [Admin Users](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/admin/users) &rarr; Sudo as **`shredr looker`** (ID `3`) &rarr; Click **Explore**.
   - **Show:** Only Marketing explores appear; Finance & AI Telemetry are hidden; PII is masked.
2. **Finance View:**
   - Click **Stop Sudoing** &rarr; Run `python3 scripts/set_persona.py finance` &rarr; Sudo as **`shredr looker`** &rarr; Click **Explore**.
   - **Show:** Only Finance explores appear; Marketing is hidden; PII is unmasked.
3. **Executive View:**
   - Click **Stop Sudoing** &rarr; Run `python3 scripts/set_persona.py executive` &rarr; Sudo as **`shredr looker`** &rarr; Click **Explore**.
   - **Show:** Only the clean, official baseline `Order Items` appears with zero departmental clutter.

---

# Slide 8: Executive Summary & Live Links Master Reference

### 🎯 Slide Purpose
Conclude the demonstration with an executive comparison matrix and provide direct links for audience evaluation.

### 🏆 Monolith vs. Hub & Spoke Scorecard

| Architectural Capability | Monolithic Project | Hub & Spoke Architecture |
| :--- | :---: | :---: |
| **Development Velocity** | 🐢 2-4 week bottleneck | ⚡ Instant departmental deploys |
| **Single Source of Truth** | ⚠️ Metric drift across copies | 🔒 Immutable central Hub views |
| **Bespoke Ingestion** | ❌ Pollutes central repository | 🚀 Spoke-exclusive isolated views |
| **Data Privacy & Governance** | ❌ Fragmented view masks | 🛡️ Inherited central PII access grants |
| **Explore Menu Clarity** | ❌ 100+ unorganized tables | 🎯 Dynamically curated per persona |

---

### 🔗 Complete Asset Directory

| Component | Repository / Project | Key File / Direct Link |
| :--- | :--- | :--- |
| **Central Hub** | `thelook-antigravity` | [`manifest.lkml`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/projects/thelook-antigravity/files/manifest.lkml) • [`explores/thelook_hub.explore.lkml`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/projects/thelook-antigravity/files/explores/thelook_hub.explore.lkml) |
| **Finance Spoke** | `thelook-finance-spoke` | [`manifest.lkml`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/projects/thelook-finance-spoke/files/manifest.lkml) • [`models/thelook_finance.model.lkml`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/projects/thelook-finance-spoke/files/models/thelook_finance.model.lkml) |
| **Marketing Spoke** | `thelook-marketing-spoke` | [`manifest.lkml`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/projects/thelook-marketing-spoke/files/manifest.lkml) • [`views/events.view.lkml`](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/projects/thelook-marketing-spoke/files/views/events.view.lkml) |
| **Core Sales Explore** | Official Spoke | [Explore Core Sales](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook/order_items) |
| **Finance Revenue Explore** | Finance Spoke | [Explore Revenue & Tax](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_finance/order_items) |
| **Finance Audits Explore** | Finance Spoke | [Explore High-Value Audits](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_finance/finance_high_value_audits) |
| **Marketing Events Explore**| Marketing Spoke | [Explore Web Traffic & Events](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_marketing/events) |
| **Marketing Audiences Explore**| Marketing Spoke | [Explore Customer Acquisition](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_marketing/users) |
| **Marketing Cohorts Explore**| Marketing Spoke | [Explore Cohorts](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_marketing/marketing_campaign_cohorts) |
