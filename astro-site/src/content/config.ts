import { defineCollection, z } from "astro:content";

const posts = defineCollection({
  type: "content",
  schema: z.object({
    title: z.string(),
    description: z.string(),
    tags: z.array(z.string()),
  }),
});

const research = defineCollection({
  type: "content",
  schema: z.object({
    title: z.string(),
    url: z.string().url(),
    source: z.string(),
    published: z.string(),
    type: z.enum([
      "docs",
      "framework",
      "paper",
      "post",
      "project",
      "protocol",
      "site",
      "talk",
    ]),
  }),
});

export const collections = { posts, research };
