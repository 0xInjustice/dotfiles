# Defining Scope and Objectives

## Importance of Client Objectives

Client objectives are the foundation of any engagement. They:

- Define what the client hopes to achieve (e.g., identifying vulnerabilities, testing security controls, or simulating an adversary's actions).
- Prevent disorganization, misaligned expectations, and wasted effort.

### Example:

If a client wants to test their network's resilience against phishing attacks but fails to express this clearly, the red team might focus on irrelevant areas like system misconfigurations.

---

## Engagement Types

Engagements can generally fall into one of two categories:

### 1. General Internal/Network Penetration Testing

- **Broad Scope:** Focuses on a wide range of systems.
- **Standard TTPs:** Uses common tactics, techniques, and procedures to identify security gaps.
- **Goal:** Evaluate general network security, uncover vulnerabilities, and recommend remediation.

#### Example:

Testing an internal network for misconfigured firewalls, weak passwords, or unpatched software.

### 2. Focused Adversary Emulation

- **Specific Focus:** Simulates the behavior of an advanced persistent threat (APT) or specific attack group targeting the client’s industry.
- **Goal:** Assess the client’s ability to detect and respond to a realistic, tailored attack scenario.

#### Example:

Emulating "APT38" (a North Korean group known for targeting financial institutions) for a bank to evaluate their defenses against such tactics.

---

## How Client Objectives Shape Engagement

Client objectives influence critical aspects of the engagement, including:

### Rules of Engagement (ROE)

Defines what is allowed during testing (e.g., are social engineering attacks permitted?).

### Scope

Specifies the systems, networks, or scenarios to test (e.g., internal networks, cloud services, or a specific application).

#### Example of Misalignment:

If a client expects a phishing simulation but doesn't communicate this, the red team might focus on network infrastructure instead, resulting in a disconnect.

---

## Engagement Planning

### Objectives vs. Plans

- **Objectives:** Set the overall goals.
- **Plans:** Map out the specific "how" of the engagement.

### Detailed Plans Include:

- Tools, techniques, and approaches the red team will use.
- Alignment with the client's goals and scope.

#### Example:

If a client’s objective is to test for lateral movement, the plan might include using simulated malware to exploit one host and jump to another.
[Lateral movement refers to the techniques attackers use to navigate through a network after gaining initial access to a system. The goal of lateral movement is to explore the environment, escalate privileges, and gain access to high-value systems or data, such as domain controllers, sensitive files, or critical applications.]

---

## Key Takeaways

- Clear client objectives are essential for a successful and efficient engagement.
- Objectives shape the type of engagement, the rules, the scope, and the specific approaches to testing.
- Communication between the client and the red team is critical to ensure mutual understanding and alignment on what will be done and why.

# Defining Scope in Engagements

## Importance of a Well-Defined Scope

The scope is a critical component of an engagement as it defines the boundaries of what can and cannot be targeted or performed during testing. A well-defined scope ensures that:

- Both the client and red team are aligned on expectations.
- The client’s infrastructure and operations are not unintentionally disrupted.
- Legal, ethical, and organizational constraints are respected.

### Key Points:

- **Client Responsibility:** The client should set the scope, though the red team may discuss concerns if the scope limits the engagement's effectiveness.
- **Dynamic Understanding:** Red teams must analyze the scope with an understanding of its implications and adapt their approach accordingly.

---

## Example Scope Verbiage

- No exfiltration of data.
- Production servers are off-limits.
- `10.0.3.8/18` is out of scope.
- `10.0.0.8/20` is in scope.
- System downtime is not permitted under any circumstances.
- Exfiltration of PII is prohibited.

---

## Example Client Objectives and Scope

### Example 1 - Global Enterprises:

#### Objectives:

- Identify system misconfigurations and network weaknesses.
- Focus on exterior systems.
- Determine the effectiveness of endpoint detection and response systems.
- Evaluate overall security posture and response:
  - SIEM and detection measures.
  - Remediation efforts.
  - Segmentation of DMZ and internal servers.[Segmentation of DMZ (Demilitarized Zone) and internal servers refers to the practice of separating and isolating network zones to enhance security and minimize the risk of unauthorized access or lateral movement by attackers.]
- Use of white cards is permitted depending on downtime and length.
- Evaluate the impact of data exposure and exfiltration.

#### Scope:

- System downtime is not permitted under any circumstances.
- Any form of DDoS or DoS is prohibited.
- Use of any harmful malware is prohibited; this includes ransomware and other variations.
- Exfiltration of PII[Personally Identifiable Information] is prohibited. Use arbitrary exfiltration data.[pecific rule for the engagement to ensure that sensitive data is not mishandled during testing]
- Attacks against systems within `10.0.4.0/22` are permitted.
- Attacks against systems within `10.0.12.0/22` are prohibited.
- Bean Enterprises will closely monitor interactions with the DMZ and critical/production systems.
- Any interaction with `*.bethechange.xyz` is prohibited.
- All interaction with `*.globalenterprises.thm` is permitted.

---

## Questions to Consider

1. How does the defined scope impact the testing strategy?
2. Are there any gaps or limitations in the scope that could affect the engagement's success?
3. Does the scope align with the client’s objectives?
4. How should the red team adapt their engagement plans to respect the scope while achieving the objectives?

# Rules of Engagement (RoE)

## Executive Summary

This document serves as an official outline for the engagement between the client and the red team. It sets the legal boundaries, expectations, and authorizations necessary for both parties to begin the engagement.

## Purpose

The purpose of this document is to define the agreed-upon terms and conditions between the client and the red team, ensuring clarity and accountability for all actions and outcomes during the engagement.

## References

- HIPAA
- ISO
- Other relevant standards or regulations

## Scope

This section outlines the specific boundaries and guidelines for the red team’s activities, including the systems, networks, and environments covered by the engagement.

## Definitions

- **Red Team**: A group tasked with simulating real-world attacks to identify vulnerabilities.
- **Client**: The organization that engages the red team for security testing.

## Rules of Engagement and Support Agreement

Defines the obligations and expectations for both parties, including general conduct, methodologies, and responsibilities during the engagement.

## Provisions

Details any exceptions or additional considerations that may impact the scope or rules of engagement.

## Requirements, Restrictions, and Authority

- Specific expectations and authority granted to the red team.
- Clear limitations on what actions the red team is authorized to perform.

## Ground Rules

Defines the red team's limitations on interaction with systems, personnel, and any other engagement parameters.

## Resolution of Issues/Points of Contact

List of key personnel involved in the engagement, including emergency contacts and escalation procedures.

## Authorization

This section confirms that both parties have authorized the engagement under the conditions outlined in this document.

## Approval

- **Client Signature**: \***\*\*\*\*\***\_\_\_\***\*\*\*\*\***
- **Red Team Signature**: \***\*\*\*\*\***\_\_\_\***\*\*\*\*\***
- **Date**: \***\*\*\*\*\***\_\_\_\***\*\*\*\*\***

## Appendix

Any further information relevant to the engagement, such as technical details, additional regulations, or additional context.

# Red Team Campaign Planning

Prior to this task, we have primarily focused on engagement planning and documentation from the business perspective. Campaign planning takes the information acquired from client objectives and the Rules of Engagement (RoE) and applies it to various plans and documents, which define how and what the red team will do during an engagement.

## Overview of Campaign Plans

Each internal red team will have its own methodology and documentation for campaign planning. Below is a summary of four detailed plans that allow for precise communication and documentation. These plans are adapted from military operations documents.

| **Type of Plan**     | **Explanation of Plan**                                                 | **Plan Contents**                                            |
| -------------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------ |
| **Engagement Plan**  | An overarching description of technical requirements for the red team.  | CONOPS, Resource and Personnel Requirements, Timelines       |
| **Operations Plan**  | An expansion of the Engagement Plan, providing more specifics.          | Operators, Known Information, Responsibilities, etc.         |
| **Mission Plan**     | The exact commands to run and execution time of the engagement.         | Commands to run, Time Objectives, Responsible Operator, etc. |
| **Remediation Plan** | Defines how the engagement will proceed after the campaign is finished. | Report, Remediation consultation, etc.                       |

## Additional Campaign Plan Example

Another example of a campaign plan is the [redteam.guide engagement checklist](#). This checklist acts as a more generalized approach to planning a campaign and outlines the information needed for red team engagements.

## Next Steps

In upcoming tasks, we will dive deeper into each of these plans, the associated documentation, and the specifics of how they contribute to campaign planning. The goal is to provide a comprehensive and actionable approach to red team operations.

# Campaign Planning Overview

Prior to this task, we have primarily focused on engagement planning and documentation from the business perspective. Campaign planning uses the information acquired and planned from the client objectives and Rules of Engagement (RoE) and applies it to various plans and documents to identify how and what the red team will do.

Each internal red team will have its methodology and documentation for campaign planning. We will be showing one in-depth set of plans that allows for precise communication and detailed documentation. The campaign summary we will be using consists of four different plans varying in-depth and coverage adapted from military operations documents. Each plan can be found in the table below with a brief explanation.

| Type of Plan     | Explanation of Plan                                                              | Plan Contents                                                |
| ---------------- | -------------------------------------------------------------------------------- | ------------------------------------------------------------ |
| Engagement Plan  | An overarching description of technical requirements of the red team.            | CONOPS, Resource and Personnel Requirements, Timelines       |
| Operations Plan  | An expansion of the Engagement Plan. Goes further into specifics of each detail. | Operators, Known Information, Responsibilities, etc.         |
| Mission Plan     | The exact commands to run and execution time of the engagement.                  | Commands to run, Time Objectives, Responsible Operator, etc. |
| Remediation Plan | Defines how the engagement will proceed after the campaign is finished.          | Report, Remediation consultation, etc.                       |

Another example of a campaign plan is the [redteam.guide engagement checklist](https://redteam.guide). The checklist acts as a more generalized approach to planning a campaign and information needed.

In the upcoming tasks, we will go further in-depth with these plans, documentation, and specifics of each as we take a deep dive into campaign planning.

# Campaign Planning Overview

Engagement documentation is an extension of campaign planning where ideas and thoughts of campaign planning are officially documented. In this context, the term "document" can be deceiving as some plans do not require proper documentation and can be as simple as an email. This will be covered in later tasks.

In this task, we will cover a technical overview of the contents of each campaign plan prior to looking at the plans and documents themselves in upcoming tasks.

## Engagement Plan

| **Component**                      | **Purpose**                                                                                                                                       |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| **CONOPS (Concept of Operations)** | Non-technically written overview of how the red team meets client objectives and targets the client.                                              |
| **Resource plan**                  | Includes timelines and information required for the red team to be successful—any resource requirements: personnel, hardware, cloud requirements. |

## Operations Plan

| **Component**              | **Purpose**                                                 |
| -------------------------- | ----------------------------------------------------------- |
| **Personnel**              | Information on employee requirements.                       |
| **Stopping conditions**    | How and why the red team should stop during the engagement. |
| **RoE (optional)**         | -                                                           |
| **Technical requirements** | What knowledge the red team will need to be successful.     |

## Mission Plan

| **Component**                    | **Purpose**                                                                                                                               |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| **Command playbooks (optional)** | Exact commands and tools to run, including when, why, and how. Commonly seen in larger teams with many operators at varying skill levels. |
| **Execution times**              | Times to begin stages of engagement. Can optionally include exact times to execute tools and commands.                                    |
| **Responsibilities/roles**       | Who does what, when.                                                                                                                      |

## Remediation Plan (optional)

| **Component**                | **Purpose**                                                                                                                               |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| **Report**                   | Summary of engagement details and report of findings.                                                                                     |
| **Remediation/consultation** | How the client will remediate findings. This can be included in the report or discussed in a meeting between the client and the red team. |

# Concept of Operations (CONOPS)

## Client Information

**Client Name:**  
Holo Enterprises

**Service Provider:**  
TryHackMe

**Timeframe:**  
One month

---

## General Objectives/Phases

1. Utilize an **assumed breach model** starting at Tier 3 infrastructure.
2. Conduct **progressive reconnaissance** and escalate privileges if objectives are not met.
3. Execute and maintain **persistence** for a period of three weeks.
4. Conduct clean-up and remediation on the final engagement day.

---

## Training Objectives

- Assess the **blue team's ability** to identify and defend against live intrusions and attacks.
- Identify the risk posed by an adversary within the internal network.

---

## High-Level Tools/Techniques Planned

- **Primary Tool:** Cobalt Strike
- **Other Standard Tooling:** Tools identifiable to the targeted threat.

---

## Threat Group Emulation

- Threat Group: **FIN6**
- **TTPs** employed will align with the group’s documented behaviors.

---

### Key Notes

- A **trusted agent** will intervene if the red cell is identified or burned by the blue cell.
- All activities and findings will be documented for a final consultation with the blue and white cells.

---

### Questions and Analysis

1. **What are the objectives of this engagement?**

   - To evaluate the blue team’s ability to detect and respond to live attacks.
   - To identify potential risks and vulnerabilities within the internal network.

2. **What tooling is used during the engagement?**

   - Cobalt Strike as the primary tool, alongside other standard tools tailored to emulate FIN6 behaviors.

3. **What threat group is being emulated, and why?**

   - FIN6, chosen due to their specific tactics and relevance to the client’s security posture.

4. **What is the engagement's timeline, and how is it structured?**

   - A one-month timeline: three weeks of active operations, and one week for remediation and consultation.

5. **What role does the trusted agent play in the engagement?**
   - Intervenes if the red cell is compromised or detected by the blue cell.

---

### Summary

The CONOPS provides a structured high-level overview of the engagement objectives, methodologies, and tools while ensuring clear communication with both technical and non-technical stakeholders. The document ensures that both business and red team goals are aligned, with precise definitions and a digestible structure for readers.

# Resource Plan

## Header

**Client Name:**  
Holo Enterprises

**Service Provider:**  
TryHackMe

---

## Personnel Writing

- Red Team Members:
  - Lead Operator
  - Reconnaissance Specialist
  - Exploitation Specialist
  - Persistence and Escalation Specialist
  - Clean-up and Remediation Specialist

---

## Dates

- **Engagement Dates:**

  - Start Date: January 15, 2025
  - End Date: February 15, 2025

- **Reconnaissance Dates:**

  - January 15, 2025 - January 18, 2025

- **Initial Compromise Dates:**

  - January 19, 2025 - January 22, 2025

- **Post-Exploitation and Persistence Dates:**

  - January 23, 2025 - February 8, 2025

- **Miscellaneous Dates:**
  - Final consultation and clean-up: February 14, 2025

---

## Knowledge Required (Optional)

- **Reconnaissance:**

  - Familiarity with network scanning and enumeration tools.
  - Ability to interpret and assess open-source intelligence (OSINT) data.

- **Initial Compromise:**

  - Knowledge of common web and network vulnerabilities.
  - Proficiency in exploitation frameworks (e.g., Cobalt Strike, Metasploit).

- **Post-Exploitation:**
  - Techniques for privilege escalation and lateral movement.
  - Maintaining persistence within a network.

---

## Resource Requirements

### Personnel

- **Red Team Personnel:**

  - Operators with experience in penetration testing, advanced exploitation techniques, and persistence methods.

- **Blue Team Coordination:**
  - Engagement with the blue team for detection and response testing.

### Hardware

- **Required Devices:**
  - Personal laptops for each team member with specific testing tools pre-installed.
  - Secure servers for command and control, if needed.

### Cloud

- **Cloud Resources (if needed):**
  - Virtualized environments for simulated attacks on infrastructure.
  - Cloud storage for tool hosting and data exfiltration simulations.

### Miscellaneous

- **Software Requirements:**

  - Offensive security tools (Cobalt Strike, Nmap, Burp Suite, etc.)
  - Secure communication platforms (encrypted emails, secure messaging).

  # Operations Plan

## Header

**Client Name:**  
Holo Enterprises

**Service Provider:**  
TryHackMe

---

## Personnel Writing

- Red Team Members:
  - Lead Operator
  - Reconnaissance Specialist
  - Exploitation Specialist
  - Persistence and Escalation Specialist
  - Clean-up and Remediation Specialist

---

## Dates

- **Engagement Dates:**

  - Start Date: January 15, 2025
  - End Date: February 15, 2025

- **Halting/Stopping Conditions:**
  - Immediate halt if blue team detects the red team and it interferes with the engagement.
  - Engagement will also be halted if legal or ethical boundaries are inadvertently crossed.
  - Stop condition will occur if the client’s systems become destabilized or negatively impacted beyond agreed-upon limits.

---

## Required/Assigned Personnel

- **Lead Operator:**
  - Responsible for overall engagement execution and coordination with the blue team.
- **Reconnaissance Specialist:**
  - Conducts initial footprinting, scanning, and vulnerability assessment.
- **Exploitation Specialist:**
  - Executes initial compromise and advanced exploitation techniques.
- **Persistence and Escalation Specialist:**
  - Ensures maintained access and lateral movement throughout the engagement.
- **Clean-up and Remediation Specialist:**
  - Ensures complete system clean-up and final report generation, including recommendations for remediation.

---

## Specific TTPs and Attacks Planned

- **Reconnaissance:**

  - External network scanning using tools like Nmap and Masscan.
  - OSINT gathering via platforms like Shodan and LinkedIn.
  - Targeting exposed services and weak points in the network infrastructure.

- **Initial Compromise:**

  - Exploiting vulnerable web applications (e.g., SQL injection, XSS).
  - Phishing attack simulations to gain initial access via social engineering.
  - Exploiting public vulnerabilities such as CVE exploits.

- **Post-Exploitation and Persistence:**
  - Establishing reverse shells with persistence via tools like Cobalt Strike.
  - Lateral movement using Kerberos or SMB to escalate privileges.
  - Data exfiltration simulations through secure channels.

---

## Communications Plan

- **Red Team to Client (General Communications):**

  - Primary platform: **Email** (for formal updates, emergency notices).
  - Secondary platform: **Slack** (for real-time status updates and coordination).

- **Red Team to Blue Team:**

  - Regular communication through **Slack** for coordination.
  - Use of **Vectr.io** for logging of all actions and progress tracking.

- **Emergency Communication:**
  - A direct line via encrypted messaging (e.g., Signal) for critical alerts or incidents that require immediate action.

---

## Rules of Engagement (Optional)

- **Scope of Testing:**

  - Only systems and assets within the agreed-upon scope of the infrastructure may be targeted.
  - No denial of service attacks unless specifically requested.

- **Ethical Boundaries:**

  - Avoid any testing that might cause harm to the client’s systems, users, or operations outside of the agreed scope.
  - Testing should not involve sensitive client data unless prior consent is obtained.

- **Reporting and Documentation:**
  - Immediate reporting of any critical vulnerabilities or issues discovered.
  - Detailed documentation of all actions taken throughout the engagement.
