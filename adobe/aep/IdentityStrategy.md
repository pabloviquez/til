# Guide for Identity Strategy

## Intro
I wanted to write a short guide to defining an identity strategy that holds up in production based on my learnings and experiences. However, this requires providing context and going through some concepts that are important to understand before defining the strategy.

## What is an Identity Strategy?
The Identity Strategy is key when starting an Adobe Experience Platform (AEP) implementation, as it's the foundation for how the project will structure its data, how the different use-cases will be implemented, and how the data will be used to create a single customer view.

> [!IMPORTANT]
> 👍🏼 A good identity strategy definition helps keep costs under control, as Adobe charges per **Addressable Audience**.
>
> 🪢 Strict or aggressive strategy can inflate profile counts due to fragmentation leading to higher costs and a more complex implementation. 🧶 A loose strategy could cause profile collapse creating a bad customer experience and even legal issues.

An identity strategy should answer the following questions:
- What makes a profile unique?
- How can I identify a profile and which identifiers have priority?
- What rules does my graph identity follow?
- How are the schemas structured and profiles stitched together?

## What makes a profile unique?
I come from a _transactional_ background, where the unique identifier is usually a primary key in a database, and while this concept is also true in AEP, we must take a step back and see profiles as **objects** first.

### Case - Store
> **Example Use Case**
>
> Let's say we have a store called *"Swim Journey"*. The store offers swimming lessons along with swimming gear and accessories. They also have a website where customers book **appointments** for the lessons and also can purchase products. The experience is similar in the mobile app.
>
> Customers use their email to log in to the website or app, and they opt-in to receive communications from the store by email and push notifications.
>
> Customers are able to book appointments for swimming lessons online, and new customers can create an account on the website or app, but the actual customer identifier will not be available until the customer completes their subscription and signs the paperwork in the physical store.

In this example, we can identify the following concepts:
- **Customer**: The person that is buying products or booking appointments.
- **Appointment**: The booking of a swimming lesson.
- **Product**: An item available for purchase in the store.

<picture>
  <img src="/adobe/aep/assets/IdentityStrategy-Concepts.png?v=2" alt="Swim Journey Store Concepts" width="550" />
</picture>

We can see that the **Customer** is the main object, and the **Appointment** and **Product** are related to it, still concepts that require unique identification but we're going to communicate to **Customers**, this will be our **Addressable Audience**.

Now the question, **how do we identify a customer?**
In the *Swim Journey* example, we can identify customers by their email address, but later we found that the store also has a unique customer identifier in their database called **SwimmerID** which is different from the email address.

For this case we will define two identifiers for the **Customer** object:
- **Email_LC_SHA256**: The email address of the customer. LC stands for LowerCase and hashed with SHA256 algorithm.
- **Swimmer_ID**: The unique identifier of the customer in the store's database

**Swim Journey** will use both identifiers to define a unique customer. In this case, **SWIMMER_ID** and **Email_LC_SHA256**.

> [!TIP]
> **Email_LC_SHA256** Sounds complicated but it's a common practice and a good one, as it allows to use the email address as an identifier but also protects the *privacy* of the customer by hashing it. The lowercasing is also important as it avoids duplicates due to case sensitivity.
>
> Having **Email_LC_SHA256** as an identifier will also help you if you ever make use of the Real Time CDP. If you later want to use RTCDP, having the **Email_LC_SHA256** as an identifier is used for different platforms identification and you'll be glad you did.

## How can I identify a profile and which identifiers have priority?
In this step, we define the identifiers and create all necessary namespaces in AEP.

Following the **Swim Journey** case, we can define the following identifiers for the **Customer** object:
- **Swimmer_ID**: The unique identifier of the customer in the store's database.
- **Email_LC_SHA256**: The email address of the customer. LC stands for LowerCase and hashed with SHA256 algorithm.

We now know **Swimmer_ID**, and **Email_LC_SHA256** are what makes a profile unique.

**What about appointments and products?**
For the case we're solving for, these concepts are very important but not part of the **Addressable Audience**. We have to separate the concepts between what makes a profile and what actions are customers taking.

The *Identity Strategy* defines the rules for the profile, what *objects* identify a customer, and how do they relate to each other. Appointments are customer actions that have different states (Scheduled, Canceled, Updated, etc) and products are "Non-people identifiers" that are related to the customer but not part of the profile.

> [!TIP]
> Create the identifiers you actually need, and not the ones you think you will need. A good design should allow you to scale.

**Another** identifier we cannot forget is the **ECID**. When a customer uses the website or mobile app, Adobe's Web and Mobile SDKs generate a sticky identifier called the Experience Cloud Identifier, or ECID.

An ECID is unique per browser or app installation. The same phone can produce three different ECIDs: one in Safari, one in Chrome, one in the app. ECIDs can be also removed, clearing cookies, private browsing, and app reinstalls all generates a new one.

**Identity Graph**
Now that we have a clear definition of what makes a profile unique, we can move to the next step, which is defining the **Identity Graph**.

| Namespace Identifier | Description | Value Example |
|---------------------|----------|-------------|
| `Swimmer_ID` | The unique identifier of the customer in the store's database | `67676767` |
| `Email_LC_SHA256` | Customer unique identifier, this is the email address of the customer. LC stands for LowerCase and hashed with SHA256 algorithm. | `74feeaab0b49db3ccf547fef30c7f81f8ee44b4793bee57762e2e75fd300942a` |
| `Product_ID` | Product unique code. Identifies the product in the store's database. | `FN-PADDLE-GRAY-L` |
| `ECID` | Experience Cloud Identifier. Unique identifier generated by Adobe Experience Platform for each customer device. | `11826660381982253663128420266683722370` |

With this information we can see how the **Identity Graph** will look like:

<picture>
  <img src="/adobe/aep/assets/IdentityStrategy-Graph.png" alt="AEP Identity Graph" width="550" />
</picture>

> [!NOTE]
> The **Identity Graph** is a representation of how the different identifiers relate to each other and how are they used to identify a profile.

In our example, three identities are tied together by a single event. This translates to: `A single customer profile `SWIMMER_ID` is associated with one event that ties together their Email_LC_SHA256, and ECID`.

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
> Not defining the rules and priorities causes profiles to be linked together incorrectly, to the point of having customers receiving notifications for someone else's activity. I'll address **Profile Collapse** in a later post, but for now let's say we don't want that for our store **Swim Journey**.

For Swim Journey, the namespace and identity types break down as follows:

| Namespace Identifier | Namespace Type | Identity Type |
|----------------------|----------------|--------------|
| `Swimmer_ID` | Custom Namespace | `Cross-Device ID` |
| `Email_LC_SHA256` | Standard Namespace | `Email` |
| `ECID` | Standard Namespace | `Cookie ID` |
| `Product_ID` | Custom Namespace | `Non-people identifier` |

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

In this configuration, a profile *uniqueness* is defined by the **Swimmer_ID**, and the **Email_LC_SHA256**.

## How are the schemas structured and profiles stitched together?

We have:
- ✅ Identified the profile concepts and how they relate to each other.
- ✅ Created namespaces for each one of them.
- ✅ Defined the rules for the identity linking rules graph.

The next step is to define how data is put together in a single profile, this is where the **Merge Policies** comes in.

> [!NOTE]
> **Merge Policies** are the rules that tell Adobe Experience Platform how to bring fragments of data, and combine them in a prioritized manner to create a Real-Time Customer Profile.
>
> **Identity Service** is a service within Experience Platform that links (or unlinks) identities to maintain identity graphs.

There are two possible merge methods available for merge policies:
- **Dataset precedence**: In the event of a conflict, give priority to profile fragments based on the dataset from which they came.
- **Timestamp ordered**: In the event of a conflict, priority is given to the profile fragment which was updated most recently.

See [Merge Policies Overview](https://experienceleague.adobe.com/en/docs/experience-platform/profile/merge-policies/overview)

For **Swim Journey Store**, I'm going to pick **timestamp ordered** as the merge method, as it makes more sense to have the most recent data in the profile. This is the most common approach and the one that works for most use cases, but there are cases where **dataset precedence** is a better approach, for example, when you have a dataset with verified data and another dataset with unverified data.

<picture>
  <img src="/adobe/aep/assets/IdentityStrategy-MergePolicy.png" alt="AEP Merge Policy" width="550" />
</picture>

### Schemas
For the last part, we now move to **Schemas** and how to create them so they work for our strategy. Schemas defines how the data is going to be structured and stored in the AEP datasets.

> [!CAUTION]
> When working with schemas, **NEVER** enable the schemas for profile unless **YOU'RE SURE** everything works as expected.
>
> **ONCE a schema is enabled for profile, it cannot be deleted**

<picture>
  <img src="/adobe/aep/assets/test-in-production-meme-1.jpg" alt="Test in Production Meme" width="550" />
</picture>

The first thing to define is how are schemas going to identify profiles. We know that **Swimmer_ID** and **Email_LC_SHA256** are the identifiers that make a profile unique, but *how do we set the schemas to use them?*

The answer is the **Primary Identity** in the schema. The primary identity is the identifier that will be used to identify a profile in the schema.

> [!TIP]
> Create a field group for the identifiers, so it can be reused in different schemas.

As an example, I created a field group called **SJ Identity Core v1**:
<picture>
  <img src="/adobe/aep/assets/IdentityStrategy-SchemaFieldGroup.png" alt="Schema Field Group" width="550" />
</picture>

**Identity Map VS Primary Identities**
Identity Map is a field that provides flexibility on how do you store the identity used and how multiple identities are linked together. This field is a JSON object, making the update more complex. Don't get me wrong, I love using it whenever I can, but for a base profile schema, let's keep it simple.

<picture>
  <img src="/adobe/aep/assets/IdentityStrategy-SchemaIdentity.png" alt="Schema Primary Identity" width="550" />
</picture>

> [!TIP]
> Don't be shy to add descriptions. The more you can document your schemas the better. Adobe CX Enterprise Coworker and other AI tools will read them and have better understanding of your data.

Don't forget to document this process and share it with anybody working in the project, as it will help them navigate the identities and follow the standard you've created.

# Summary - Printable Version

I created a Word document with a simple summary to print and use as a reference for your identity strategy. [Download Identity StrategyGuide.docx](/adobe/aep/assets/IdentityStrategyGuide.docx)