# Guide for Identity Strategy

## Intro
I wanted to write a quick guide to succesfully define the profile strategy based on my learnings and experiences. However, this requires to provide context and go over some concepts that are important to understand before defining the strategy.

## What is an Identity Strategy?
This is key when taking over an Adobe Experience Platform (AEP) implementation, as it's the base on how the project will structure it's data, how the different use-cases will be implemented and how the data will be used to create a single customer view.

> [!IMPORTANT]
> A good definition can help on keeping cost under control, as Adobe charges per **Addressable Profile**, a loose strategy can lead to higher costs and a more complex implementation.

An identity strategy should answer the following questions:
- What makes a profile unique?
- How can I identify a pro◊file and which identifiers have priority?
- What rules does my graph identity follow?
- How are my schemas structured and how do they relate to each other?

## What makes a profile unique?
I come from an _transactional_ background, where the unique identifier is usually a primary key in a database, and while this concept is also true in AEP, we must take a step back and see profiles as **objects** first.

### Case - Store
> **Example Use Case**
>
> Let's say we have a store called *"Swim Journey"*. The store offers swimming lessons along with swimming gear and accessories. They also have a website where customers book **appointments** for the lessons and also can purchase products. The experience is similar in the mobile app.

In this example, we can identify the following concepts:
- **Customer**: The person that is buying products or booking appointments.
- **Appointment**: The booking of a swimming lesson.
- **Product**: An item available for purchase in the store.

<picture>
  <img src="/adobe/aep/assets/IdentityStrategy-Concepts.png" alt="Swim Journey Store Concepts" width="550" />
</picture>


