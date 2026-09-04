# 🏛️ Looker Hub & Spoke Architecture: Master Presentation & Live Demo Playbook

**Target Audience:** Looker Developers, BI Engineers, Data Leads, and Enterprise Architects.  
**Instance Base URL:** `https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app`

---

## 1. Executive Summary: Why Hub & Spoke? (Multi-Persona Value)

As organizations scale, a purely centralized data team becomes a bottleneck. The **Hub & Spoke** architecture decentralizes development velocity while preserving strict centralized data governance.

```mermaid
graph TD
    subgraph CentralHub["🏛️ Central Governed Hub (thelook-antigravity)"]
        HV["<b>Governed Views</b> (<code>thelook_views/</code>)<br/>• Single Source of Truth metrics<br/>• Explicit Primary Keys<br/>• Reusable PDTs (<code>user_order_facts</code>)"]
        HE["<b>Generic Explore Templates</b> (<code>explores/thelook_hub.explore.lkml</code>)<br/>• Standard joins & relationships<br/>• <i>Zero queryable models in Hub</i>"]
        HM["<b>Project Manifest</b> (<code>manifest.lkml</code>)<br/>• <code>project_name: 'thelook-antigravity'</code>"]
    end

    CentralHub ==>|"Project Import<br/>(<code>local_dependency</code>)"| SpokeOfficial["🔵 <b>Official Spoke</b> (Core Sales)<br/>• Company-wide baseline explores<br/>• Executive KPIs"]
    CentralHub ==>|"Project Import<br/>(<code>local_dependency</code>)"| SpokeMktg["🟢 <b>Marketing Spoke</b><br/>• Refinements (<code>users_rfn</code>)<br/>• Extensions (<code>users_ext</code>)<br/>• Campaign Attribution"]
    CentralHub ==>|"Project Import<br/>(<code>local_dependency</code>)"| SpokeFin["🟡 <b>Finance Spoke</b><br/>• Refinements (<code>order_items_rfn</code>)<br/>• Extensions (<code>order_items_ext</code>)<br/>• Tax Liability & Margin"]
    CentralHub ==>|"Project Import<br/>(<code>local_dependency</code>)"| SpokeUseCase["🟣 <b>Use-Case Spoke</b> (Conversational Analytics)<br/>• GenAI chat telemetry & LLM logs"]
```

### Stakeholder Value Matrix

| Persona | Core Pain Point Solved | How Hub & Spoke Delivers It |
| :--- | :--- | :--- |
| **Central Data Architect** | Metric drift, duplicate definitions, broken production reports. | Universal business logic is maintained in the Hub; Spokes cannot alter central code. |
| **Marketing Analyst** | 3-week backlog waiting for central BI team to add campaign tags. | Autonomy to add marketing dimensions and deploy without central team approval. |
| **Finance Auditor** | Data accuracy and strict column-level PII compliance. | Core revenue numbers are immutable; PII access grants protect sensitive customer data. |
| **C-Suite Executive** | Discrepancies where Marketing and Finance dashboards report different numbers. | All departmental models inherit from the identical base views in the Hub. |
| **FinOps / Cloud DBA** | Marketing dashboard refreshes exhausting BigQuery compute slots. | Decoupled BigQuery query projects per connection isolate compute capacity. |

---

## 2. The 6 Core Enterprise Use Cases Demoed in this Repo

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│ USE CASE TAXONOMY DEMOED IN THIS CODEBASE                                                       │
├──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 1. 🏛️ Central Source of Truth (SSOT) -> Governed dimensions, primary keys, and common PDTs       │
│ 2. 🟢 Departmental Velocity (Marketing) -> Refinements (_rfn) and Campaign Cohorts (_ext)       │
│ 3. 🟡 Specialized Accounting (Finance) -> Tax liabilities, GAAP revenue, and audit explores      │
│ 4. 🟣 Single-Purpose Micro-Apps -> Dedicated GenAI Chat telemetry & LLM interaction logging     │
│ 5. 🔒 Column-Level Data Privacy -> Central PII Access Grants enforced across all Spokes         │
│ 6. 🛡️ Role-Based Model Filtering -> Looker Model Sets dynamically adapting user Explore menus    │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Real Configured Personas & Live Sudo Walkthrough

The Looker instance has been configured with **4 real user personas**, **dedicated Model Sets**, and **Roles** to showcase dynamic user access control.

### Configured Persona Roster

| Persona / User | Looker User ID | Assigned Role | Model Set | PII Access (`can_see_pii`) | Visible Explores in Menu |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Sara Chen** (Marketing Analyst) | `18` | `Marketing Analyst Role` (Role 48) | `marketing_model_set` (Model Set 36) | `No` | ✅ Core Sales (`thelook`)<br/>✅ Marketing Spoke (`thelook_marketing`)<br/>❌ Finance & GenAI Hidden |
| **Alex Mercer** (Finance Auditor) | `15` | `Finance Auditor Role` (Role 49) | `finance_model_set` (Model Set 37) | `Yes` | ✅ Core Sales (`thelook`)<br/>✅ Finance Spoke (`thelook_finance`)<br/>❌ Marketing & GenAI Hidden |
| **Elena Rostova** (Executive Leader) | `16` | `Executive Role` (Role 50) | `official_model_set` (Model Set 38) | `No` | ✅ Core Sales (`thelook`)<br/>❌ All Departmental Spokes Hidden |
| **Super Admin** (Looker Admin) | `1` | `Admin` (Role 1) | `All Models` (Model Set 1) | `Yes` | ✅ **All Explores Visible** |

---

### Step-by-Step Live Demo Script (The "Sudo" Sequence)

#### **Step 1: Start as Super Admin (Show Full Universe)**
1. In Looker, navigate to **Explore** in the top navigation bar.
2. **Show the Audience:** You can see every section: *Order Items*, *Thelook Marketing*, *Thelook Finance*, and *Conversational Analytics*.
3. Explain that an Admin sees all models, but departmental users will experience a curated, secure view.

---

#### **Step 2: Sudo as Sara Chen (Marketing Analyst)**
1. Navigate to **Admin &rarr; Users** &rarr; Find **Sara Chen** (ID `18`) &rarr; Click **Sudo**.
2. Click **Explore** in the top navigation bar.
3. **Point out to the Audience:**
   - ✅ **`Marketing Spoke`** is visible with:
     - `Marketing: Campaign Attribution & Orders`
     - `Marketing: Customer Acquisition & Audiences`
     - `Marketing: Cohort Performance Analysis`
   - ❌ **`Finance Spoke`** and **`Conversational Analytics`** are **completely hidden**.
4. Open the **`Marketing: Customer Acquisition & Audiences`** explore:
   - Notice the custom dimension **`Marketing Channel Group`** (`Search Engine`, `Social Ads`, `Direct Email CRM`).
   - Notice that the **`Email`** field is **hidden/inaccessible** because Sara has `can_see_pii = No`.

---

#### **Step 3: Sudo as Alex Mercer (Finance Auditor)**
1. Click **Stop Sudoing** in the top bar.
2. Go to **Admin &rarr; Users** &rarr; Find **Alex Mercer** (ID `15`) &rarr; Click **Sudo**.
3. Click **Explore** in the top navigation bar.
4. **Point out to the Audience:**
   - ❌ **`Marketing Spoke`** is **completely hidden**.
   - ✅ **`Finance Spoke`** is visible with:
     - `Finance: Revenue & Tax Accounting`
     - `Finance: High-Value Transaction Audits`
     - `Finance: Order Audit Trail`
5. Open **`Finance: Revenue & Tax Accounting`**:
   - Add **`Order Items -> Total Net Revenue`** and **`Order Items -> Total Estimated Tax`**.
   - Open **`Users -> Email`** &rarr; **Email is visible** because Alex has `can_see_pii = Yes`.

---

#### **Step 4: Sudo as Elena Rostova (Executive Leader)**
1. Click **Stop Sudoing** &rarr; Sudo as **Elena Rostova** (ID `16`).
2. Click **Explore** &rarr; **Point out:** Only the clean, global **`Order Items`** and **`Users`** explores appear. No departmental clutter or raw telemetry.

---

## 4. Verified Live API Query Outputs (Proof of Execution)

All models and explores have been executed and verified against live BigQuery data:

### 1. Hub Core Explore (`thelook` &rarr; `order_items`)
```json
[
  {"order_items.status": "Shipped",    "order_items.total_sale_price": 3266552.02},
  {"order_items.status": "Complete",   "order_items.total_sale_price": 2696200.89},
  {"order_items.status": "Processing", "order_items.total_sale_price": 2136400.80}
]
```

### 2. Hub Core Demographics (`thelook` &rarr; `users`)
```json
[
  {"users.country": "China",         "users.count": 33756},
  {"users.country": "United States", "users.count": 22726},
  {"users.country": "Brasil",        "users.count": 14489}
]
```

### 3. Use-Case Spoke (`conversational_analytics` &rarr; `interaction_logs`)
```json
[
  {"interaction_logs.interaction_count": 726}
]
```

---

## 5. Architectural Deep-Dive (LookML Code Anatomy)

### 1. Refinements (`_rfn.view.lkml`) vs. Extensions (`_ext.view.lkml`)

```lookml
# REFINEMENT PATTERN (spoke_views/marketing_users_rfn.view.lkml)
# In-place augmentation without changing view name:
view: +users {
  dimension: marketing_channel_group {
    type: string
    sql: CASE WHEN ${traffic_source} = 'Search' THEN 'Search Engine' ... END ;;
  }
}

# EXTENSION PATTERN (spoke_views/marketing_users_ext.view.lkml)
# Creates a distinct copy to prevent naming conflicts:
view: marketing_users_ext {
  extends: [users]
  dimension: campaign_cohort {
    type: string
    sql: CONCAT('Cohort-', ${created_quarter}) ;;
  }
}
```

### 2. Central Governed PII Access Grant
```lookml
# Hub Model / Views
access_grant: pii_data {
  user_attribute: can_see_pii
  allowed_values: ["Yes", "yes", "true"]
}

# thelook_views/users.view.lkml
dimension: email {
  type: string
  sql: ${TABLE}.email ;;
  required_access_grants: [pii_data]
}
```

---

## 6. Direct URLs for Your Demo

| Explores | Direct URL Link |
| :--- | :--- |
| **Finance: High-Value Audits** | [Open Explore](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_finance/finance_high_value_audits) |
| **Finance: Revenue & Tax** | [Open Explore](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_finance/order_items) |
| **Finance: Order Audit Trail** | [Open Explore](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_finance/orders) |
| **Marketing: Cohort Analysis** | [Open Explore](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_marketing/marketing_campaign_cohorts) |
| **Marketing: Attribution & Orders** | [Open Explore](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_marketing/order_items) |
| **Marketing: Customer Audiences** | [Open Explore](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook_marketing/users) |
| **Core Sales (Official Spoke)** | [Open Explore](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/thelook/order_items) |
| **GenAI Chat Telemetry** | [Open Explore](https://915eab0a-ce5e-423b-81fb-1e93c2f3424d.looker.app/explore/conversational_analytics/interaction_logs) |

---

## 7. Presenter Defense Cheat Sheet

| Question from Audience | Best Practice Answer |
| :--- | :--- |
| *"Can a Spoke overwrite central calculations?"* | No. Spokes can refine or add custom dimensions, but cannot push changes upstream to the Hub repo or alter the base tables. |
| *"How do we manage BigQuery query costs across Spokes?"* | Configure separate Looker connections with dedicated GCP query/compute projects and isolated PDT scratch datasets. |
| *"How do we handle CI/CD across multiple instances?"* | Central Hub requires 4 Deploy Keys (DEV read/write; SIT, UAT, PROD read-only). Advanced Deploy Mode is used to tag and deploy releases. |
