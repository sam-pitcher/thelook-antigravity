# 🎬 Looker Hub & Spoke Live Demo: Slide Deck & Presenter Guide

> **Instance Base URL:** `https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app`  
> **Users Admin URL:** `https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/admin/users`  
> **Format:** 8 Dedicated Demo Slides for Live Presentation

---

## 📑 Demo Slide Index (8 Slides)

1. [**Slide 1:** Live Demo Overview & The Persona Switcher](#slide-1-live-demo-overview--the-persona-switcher)
2. [**Slide 2:** Demo Step 1 — Super Admin View (The Unfiltered Universe)](#slide-2-demo-step-1--super-admin-view-the-unfiltered-universe)
3. [**Slide 3:** Demo Step 2 — Marketing Analyst (Autonomy, Refinements & PII Masking)](#slide-3-demo-step-2--marketing-analyst-autonomy-refinements--pii-masking)
4. [**Slide 4:** Demo Step 3 — Spoke-Exclusive Data Ingestion (Clickstream Events)](#slide-4-demo-step-3--spoke-exclusive-data-ingestion-clickstream-events)
5. [**Slide 5:** Demo Step 4 — Finance Auditor (Extensions, Auditing & PII Access)](#slide-5-demo-step-4--finance-auditor-extensions-auditing--pii-access)
6. [**Slide 6:** Demo Step 5 — Executive Leader (Curated, Clutter-Free View)](#slide-6-demo-step-5--executive-leader-curated-clutter-free-view)
7. [**Slide 7:** Behind the Scenes — LookML Code Anatomy & Project Import](#slide-7-behind-the-scenes--lookml-code-anatomy--project-import)
8. [**Slide 8:** Demo Takeaways & Architectural Scorecard](#slide-8-demo-takeaways--architectural-scorecard)

---

# Slide 1: Live Demo Overview & The Persona Switcher

### 🎯 Slide Purpose
Introduce what the audience is about to see live: dynamic role-based explore filtering, column-level PII security, and departmental autonomy in a multi-project Hub & Spoke architecture.

### 📊 Live Demo Topology
```
                     ┌─────────────────────────────────────────┐
                     │   python3 scripts/set_persona.py <name> │
                     └────────────────────┬────────────────────┘
                                          │
       ┌──────────────────┬───────────────┴───────────────┬──────────────────┐
       ▼                  ▼                               ▼                  ▼
 [Super Admin]      [Marketing Analyst]           [Finance Auditor]     [Executive Leader]
  All Models         Marketing Spoke Only          Finance Spoke Only    Core Sales Only
  `PII = Yes`        `PII = No` (Masked)           `PII = Yes`           `PII = No`
```

### 💡 Presenter Script / Talking Points
* *"Welcome! In this live demonstration, we are going to look at Looker through the eyes of 4 distinct user personas."*
* *"Using Looker's live Sudo feature, we will watch the Explore navigation menu dynamically transform and observe how central governance rules — like PII masking — are enforced automatically across all departmental projects."*

---

# Slide 2: Demo Step 1 — Super Admin View (The Unfiltered Universe)

### 🎯 Slide Purpose
Show the baseline Looker environment as a Super Admin before demonstrating departmental isolation.

### 🖥️ Live Action & Screen Steps
1. Navigate to Looker &rarr; Click **[Explore](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/browse)** in the top navigation.
2. **Show the audience:** The complete catalog of models is visible:
   - `Order Items` *(Official Company-Wide Baseline)*
   - `Thelook Marketing` *(Departmental Marketing Spoke)*
   - `Thelook Finance` *(Departmental Finance Spoke)*
   - `Conversational Analytics` *(Dedicated AI Telemetry Spoke)*

### 💡 Presenter Script / Talking Points
* *"Right now, we are logged in as a Super Admin. We see every departmental model, every explore, and every raw table across the entire enterprise."*
* *"In a traditional monolithic setup, regular business users would be overwhelmed by this clutter or have access to data they shouldn't see. Now let's see how Hub & Spoke curates this."*

---

# Slide 3: Demo Step 2 — Marketing Analyst (Autonomy, Refinements & PII Masking)

### 🎯 Slide Purpose
Demonstrate departmental autonomy (Refinements `_rfn`) and Column-Level Security (PII Access Grants) for a Marketing user.

### 🖥️ Live Action & Screen Steps
1. **In Terminal:** Run:
   ```bash
   python3 scripts/set_persona.py marketing
   ```
2. **In Looker:** Go to [**Admin &rarr; Users**](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/admin/users) &rarr; Sudo as **`shredr looker`** (ID `3`).
3. Click **Explore** in top navigation:
   - ✅ **Show:** Only **`Thelook Marketing`** and core sales appear.
   - ❌ **Show:** **`Thelook Finance`** and **`Conversational Analytics`** are **completely invisible**.
4. Open [**`Marketing: Customer Acquisition & Audiences`**](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_marketing/users):
   - 🟢 **Show Custom Dimension:** Add **`Marketing Channel Group`** (built via Refinement `+users` without touching the Hub!).
   - 🔒 **Show PII Security:** Search for `Email` in the field picker &rarr; **Email is completely hidden** (`can_see_pii = No`).

### 💡 Presenter Script / Talking Points
* *"Notice two crucial things: First, the marketing team added their own custom dimension `Marketing Channel Group` in their own Git repository. Second, despite their autonomy, the central PII policy enforced in the Hub hid the customer's email address automatically."*

---

# Slide 4: Demo Step 3 — Spoke-Exclusive Data Ingestion (Clickstream Events)

### 🎯 Slide Purpose
Showcase how a department can ingest high-volume bespoke data directly into their Spoke without polluting the central Hub.

### 🖥️ Live Action & Screen Steps
1. In the Explore menu (still as Marketing persona), open [**`Marketing: Web Traffic & Event Clickstream`**](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_marketing/events).
2. **Build a quick query:**
   - Select **`Events -> Event Type`**
   - Select **`Events -> Count`**
   - Select **`Users -> State`** *(Joined from central Hub view!)*
3. Click **Run**.

### 💡 Presenter Script / Talking Points
* *"In a traditional setup, adding high-volume clickstream logs would pollute the central repository and slow down unrelated queries."*
* *"With Hub & Spoke, Marketing ingested `events` exclusively into their spoke, joined it seamlessly with the governed central `users` view from the Hub, while keeping the central Hub completely pristine."*

---

# Slide 5: Demo Step 4 — Finance Auditor (Extensions, Auditing & PII Access)

### 🎯 Slide Purpose
Demonstrate specialized accounting metrics, LookML Extensions (`_ext`), and unmasked PII access for compliance auditing.

### 🖥️ Live Action & Screen Steps
1. **In Looker:** Click **Stop Sudoing** in the yellow top banner.
2. **In Terminal:** Run:
   ```bash
   python3 scripts/set_persona.py finance
   ```
3. **In Looker:** Go to [**Admin &rarr; Users**](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/admin/users) &rarr; Sudo as **`shredr looker`** (ID `3`).
4. Click **Explore**:
   - ❌ **Show:** **`Thelook Marketing`** is **completely hidden**.
   - ✅ **Show:** **`Thelook Finance`** is visible (`Revenue & Tax Accounting`, `High-Value Audits`).
5. Open [**`Finance: Revenue & Tax Accounting`**](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_finance/order_items):
   - 🟡 **Show Specialized Measures:** Add **`Total Net Revenue`** and **`Total Estimated Tax`**.
   - 🔓 **Show PII Access:** Open **`Users -> Email`** &rarr; **Email is unmasked and visible** because Finance auditors have `can_see_pii = Yes`!
6. Open [**`Finance: High-Value Transaction Audits`**](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_finance/finance_high_value_audits):
   - 🟡 **Show Extension:** Point out the custom view extension `order_items_ext` filtering transactions over $500.

### 💡 Presenter Script / Talking Points
* *"Finance has their own dedicated GAAP metrics and audit trails. Because this user is an authorized auditor, the central PII access grant automatically reveals the customer email address for compliance verification."*

---

# Slide 6: Demo Step 5 — Executive Leader (Curated, Clutter-Free View)

### 🎯 Slide Purpose
Show how C-Suite executives and general business users get a clean, official Single Source of Truth with zero departmental clutter.

### 🖥️ Live Action & Screen Steps
1. **In Looker:** Click **Stop Sudoing**.
2. **In Terminal:** Run:
   ```bash
   python3 scripts/set_persona.py executive
   ```
3. **In Looker:** Sudo as **`shredr looker`** (ID `3`) &rarr; Click **Explore**:
   - 🌟 **Show:** Only the official **`Order Items`** and **`Users`** baseline explores appear.
   - ❌ **Show:** Zero marketing campaign sprawl, zero accounting audit explores, zero AI telemetry tables.
4. Open [**`Order Items (Core Sales)`**](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook/order_items):
   - Add **`Order Items -> Status`** and **`Order Items -> Total Sale Price`**.
   - Click **Run**.

### 💡 Presenter Script / Talking Points
* *"Executives don't want to dig through 50 departmental tables to find top-line company sales. Hub & Spoke gives them a clean, certified baseline where metrics are guaranteed to match what Marketing and Finance report."*

---

# Slide 7: Behind the Scenes — LookML Code Anatomy & Project Import

### 🎯 Slide Purpose
Walk technical stakeholders through the actual code mechanics powering the demo: `manifest.lkml`, `hidden: yes` defaults, and Refinements.

### 📊 Code Mechanics Breakdown

```lookml
# 1. SPOKE PROJECT MANIFEST (thelook-marketing-spoke/manifest.lkml)
project_name: "thelook_marketing"
local_dependency: {
  project: "thelook-antigravity" # Central Hub Dependency
}

# 2. CENTRAL HUB EXPLORE TEMPLATE (thelook-antigravity/explores/thelook_hub.explore.lkml)
# Hidden by default to prevent explore menu pollution across Spokes:
explore: order_items {
  hidden: yes
  label: "Order Items"
  join: users { sql_on: ${users.id} = ${order_items.user_id} ;; }
}

# 3. SPOKE MODEL FILE (thelook-marketing-spoke/models/thelook_marketing.model.lkml)
# Selectively unhides and rebrands for Marketing:
include: "//thelook-antigravity/thelook_views/**/*.view.lkml"
include: "//thelook-antigravity/explores/thelook_hub.explore.lkml"

explore: +order_items {
  hidden: no
  label: "Marketing: Campaign Attribution & Orders"
  group_label: "Marketing Spoke"
}
```

### 💡 Presenter Script / Talking Points
* *"Three key architectural decisions make this work seamlessly:*
  1. *Looker's `local_dependency` imports the Hub as a read-only library.*
  2. *Setting `hidden: yes` in the Hub ensures only explicitly unhidden explores appear.*
  3. *Refinements (`+view` and `+explore`) let Spokes brand and augment without breaking central code."*

---

# Slide 8: Demo Takeaways & Architectural Scorecard

### 🎯 Slide Purpose
Summarize the business and technical value delivered by the demonstrated architecture.

### 🏆 Enterprise Architecture Scorecard

| Architectural Feature | Traditional Monolith | Hub & Spoke Architecture |
| :--- | :---: | :---: |
| **Development Velocity** | 🐢 2-4 week sprint backlog | ⚡ Instant departmental deploys |
| **Data Governance (SSOT)** | ⚠️ Metric drift across copies | 🔒 Central immutable Hub views |
| **Explore Menu Clarity** | ❌ 100+ unorganized tables | 🎯 Dynamically curated per role |
| **Data Privacy (PII)** | ❌ Fragmented view masks | 🛡️ Central PII Grants across all Spokes |
| **Compute / FinOps Isolation** | ❌ Runaway query slot starvation | 💰 Dedicated BigQuery query projects |

---

### 🔗 Quick Link Matrix for Live Demo

| Persona to Demo | Helper Switcher Command | Looker Explore Link |
| :--- | :--- | :--- |
| **Super Admin** | `python3 scripts/set_persona.py admin` | [Explore Catalog](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/browse) |
| **Marketing Analyst** | `python3 scripts/set_persona.py marketing` | [Marketing Audiences](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_marketing/users) |
| **Marketing Clickstream** | `python3 scripts/set_persona.py marketing` | [Web Traffic & Events](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_marketing/events) |
| **Finance Auditor** | `python3 scripts/set_persona.py finance` | [Finance Audits](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_finance/finance_high_value_audits) |
| **Executive Leader** | `python3 scripts/set_persona.py executive` | [Core Sales](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook/order_items) |
