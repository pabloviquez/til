# Guide for Identity Strategy

## Intro
I wanted to write a quick guide to successfully define the profile strategy based on my learnings and experiences. However, this requires to provide context and go over some concepts that are important to understand before defining the strategy.

## What is an Identity Strategy?
This is key when taking over an Adobe Experience Platform (AEP) implementation, as it's the base on how the project will structure it's data, how the different use-cases will be implemented and how the data will be used to create a single customer view.

> [!IMPORTANT]
> A good definition can help on keeping cost under control, as Adobe charges per **Addressable Profile**, a loose strategy can lead to higher costs and a more complex implementation.

An identity strategy should answer the following questions:
- What makes a profile unique?
- How can I identify a profile and which identifiers have priority?
- What rules does my graph identity follow?
- How are the schemas structured and profiles stitched together?

## What makes a profile unique?
I come from an _transactional_ background, where the unique identifier is usually a primary key in a database, and while this concept is also true in AEP, we must take a step back and see profiles as **objects** first.

### Case - Store
> **Example Use Case**
>
> Let's say we have a store called *"Swim Journey"*. The store offers swimming lessons along with swimming gear and accessories. They also have a website where customers book **appointments** for the lessons and also can purchase products. The experience is similar in the mobile app.
>
> Customers uses the email to login in the website or app, and they opt-in to receve communications from the store by email and push notifications.
>
> Customers are able to book appointments for swimming lessons online, they can create a new account in the web and book an appointment. AEP will not receive the `Swimmer_ID` until one or two days later.

In this example, we can identify the following concepts:
- **Customer**: The person that is buying products or booking appointments.
- **Appointment**: The booking of a swimming lesson.
- **Product**: An item available for purchase in the store.

<picture>
  <img src="/adobe/aep/assets/IdentityStrategy-Concepts.png?v=2" alt="Swim Journey Store Concepts" width="550" />
</picture>

We can see that the **Customer** is the main object, and the **Appointment** and **Product** are related to it, still concepts that requires unique identification but we're going to communicate to **Customers**, this will be our **Addressable Profile**.

Now the question, **how do we identify a customer?**
In the *Swim Journey* example, we can identify customers by their email address, but later we found that the store also has a unique customer identifier in their database called **SwimmerID** which is different from the email address.

For this case we will define two identifiers for the **Customer** object:
- **Email_LC_SHA256**: The email address of the customer. LC stands for LowerCase and hashed with SHA256 algorithm.
- **Swimmer_ID**: The unique identifier of the customer in the store's database

**Swim Journey** will use both identifiers to define a unique customer. In this case, **SWIMMER_ID** and **Email_LC_SHA256**.

> [!TIP]
> **Email_LC_SHA256** Sounds complicated but it's a common practice and a good one, as it allows to use the email address as an identifier but also protects the *privacy* of the customer by hashing it. The lowercasing is also important as it avoids duplicates due to case sensitivity.
>
> IF you later want to use RTCDP, having the Email_LC_SHA256 as identifier will be required.

## How can I identify a profile and which identifiers have priority?
In this step, we define the identifiers and create all necesary namespaces in AEP.

Following the **Swim Journey** case, we can define the following identifiers for the **Customer** object:
- **Swimmer_ID**: The unique identifier of the customer in the store's database.
- **Email_LC_SHA256**: The email address of the customer. LC stands for LowerCase and hashed with SHA256 algorithm.

We now know **Swimmer_ID**, and **Email_LC_SHA256** are what makes a profile unique.

But let's not forget about the other concepts, the **Appointment** and **Product** objects. We can define the following identifiers for them:
- **Appointment_ID**: The unique identifier of the appointment in the store's database.
- **Product_ID**: The unique identifier of the product in the store's database.

**Another** identifier we cannot forget is the **ECID**. As customer uses the website and mobile app, Adobe Experience Platform will generate an sticky identifier to the customer device, this Experience Cloud Identifier is called **ECID**. The ECID is unique per device, for example, if I browse the site using one browser, then open another browser, the ECID will be different.

**Identity Graph**
Now that we have a clear definition of what makes a profile unique, we can move to the next step, which is defining the **Identity Graph**.

| Namespace Identifier | Description | Value Example |
|---------------------|----------|-------------|
| `Swimmer_ID` | The unique identifier of the customer in the store's database | `67676767` |
| `Email_LC_SHA256` | Customer unique identifier, this is the email address of the customer. LC stands for LowerCase and hashed with SHA256 algorithm. | `74feeaab0b49db3ccf547fef30c7f81f8ee44b4793bee57762e2e75fd300942a` |
| `Appointment_ID` | The unique identifier of the appointment in the store's database. | `506834567` |
| `Product_ID` | Product unique code. Identifies the product in the store's database. | `FN-PADDLE-GRAY-L` |
| `ECID` | Experience Cloud Identifier. Unique identifier generated by Adobe Experience Platform for each customer device. | `1234567890123456789012345678901234567890` |

With this information we can see how the **Identity Graph** will look like:

<picture>
  <img src="/adobe/aep/assets/IdentityStrategy-Graph.png" alt="AEP Identity Graph" width="550" />
</picture>

> [!NOTE]
> The **Identity Graph** is a representation of how the different identifiers relate to each other and how they are used to identify a profile.

In our example, we can see how four identities relate to each other based on **1** event. We can read as follows: `One profile has one event with one Email_LC_SHA256, one Appointment_ID, and one ECID`.

> [!TIP]
> Use the AEP Graph Simulation tool to visualize your identity graph and test different scenarios.

<picture>
  <img src="/adobe/aep/assets/adobe-graph-simulator.webp" alt="AEP Graph Simulator" width="550" />
</picture>

See [Adobe Graph Simulation UI guide](https://experienceleague.adobe.com/en/docs/experience-platform/identity/features/identity-graph-linking-rules/graph-simulation).


## What rules does my graph identity follow?

The focus of this step is to set up the unique namespaces and namespace priorities.

We now have a clear picture of how the identifiers relate to each other, but we need to define the rules that will govern how the graph identity is built.

> [!WARNING]
> Not defining the rules and priorities causes profiles to be linked together incorrectly, to the point of having customers receiveing notifications for someone else activity. I'll address **Profile Collapse** in a later post, but for now let's say we don't want that for our store **Swim Journey**

Following the case of **Swim Journey**, we have another identifier which is important to consider.


| Namespace Identifier | Namespace Type | Identity Type |
|----------------------|----------------|--------------|
| `Swimmer_ID` | Custom Namespace | `Cross-Device ID` |
| `Email_LC_SHA256` | Standard Namespace | `Cross-Device ID` |
| `Appointment_ID` | Custom Namespace | `Cross-Device ID` |
| `Product_ID` | Custom Namespace | `Non-people identifier` |
| `ECID` | Standard Namespace | `Cookie ID` |

### Identity Types
| Identity Type | Description |
|---------------|-------------|
| Cookie ID | Cookie IDs identify web browsers. These identities are critical for expansion and constitute the majority of the identity graph. However, by nature they decay fast and lose their value over time.|
| Cross-Device ID | Cross-device IDs identify an individual and usually tie other IDs together. Examples include a login ID, CRMID, and loyalty ID. This is an indication to Identity Service to handle the value sensitively. |
| Non-people identifier | Non-people IDs are used for storing identifiers that require namespaces but are not connected to a person cluster. For example, a product SKU, data related to products, organizations, or stores. |

<picture>
  <img src="/adobe/aep/assets/IdentityStrategy-CustomNamespace.png" alt="AEP Custom Namespace" width="550" />
</picture>

See [Identity namespace overview](https://experienceleague.adobe.com/en/docs/experience-platform/identity/features/namespaces#identity-type) for more information.

Assuming we have the custom namespaces created, we can now define the identity **unique namespaces and namespace priorities**

<picture>
  <img src="/adobe/aep/assets/IdentityStrategy-IdentityPriority_v2.png" alt="AEP Identity Priority" width="650" />
</picture>

See [Implementation guide for Identity Graph Linking Rules](https://experienceleague.adobe.com/en/docs/experience-platform/identity/features/identity-graph-linking-rules/implementation-guide) for more information.

In this configuration, a profile *uniqueness* is defined by the **Swimmer_ID**, and the **Email_LC_SHA256** has priority over the **ECID** or **Appointment_ID**.

## How are the schemas structured and profiles stitched together?

We have:
- ✅ Identified the profile concepts and how they relate to each other.
- ✅ Created namespaces for each one of them.
- ✅ Defined the rules for the identity linking rules graph.

The next step is to define how does the data is put together in a single profile. This process that takes all data needs to follow a set of rules and policies. This is called **Merge Policies**.

> [!NOTE]
> Merge policies are rules that help Adobe Experience Platform bring fragments of data, and combine them in a prioritized manner to create a Real-Time Customer Profile.

There are two possible merge methods available for merge policies:
- **Dataset precedence**: In the event of a conflict, give priority to profile fragments based on the dataset from which they came.
- **Timestamp ordered**: In the event of a conflict, priority is given to the profile fragment which was updated most recently.

See [Merge Policies Overview](https://experienceleague.adobe.com/en/docs/experience-platform/profile/merge-policies/overview)

For **Swim Journey Store**, I'm going to pick **timestamp ordered** as the merge method, as it makes more sense to have the most recent data in the profile. This is the most common approach and the one that works for most use cases, but there are cases where **dataset precedence** is a better approach, for example, when you have a dataset with verified data and another dataset with unverified data.

<picture>
  <img src="/adobe/aep/assets/IdentityStrategy-MergePolicy.png" alt="AEP Merge Policy" width="550" />
</picture>

# Summary - Printable Version

I created a Word document with a simple summary to print and use as a reference for your identity strategy. [Download Profile Strategy Guide](/adobe/aep/assets/ProfileStrategyGuide.docx)