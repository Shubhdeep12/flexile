import { TRPCError } from "@trpc/server";
import { and, desc, eq } from "drizzle-orm";
import { z } from "zod";
import { db, pagination, paginationSchema } from "@/db";
import { dividendRounds } from "@/db/schema";
import { companyProcedure, createRouter } from "@/trpc";

export const dividendRoundsRouter = createRouter({
  list: companyProcedure.input(paginationSchema).query(async ({ ctx, input }) => {
    if (!ctx.company.dividendsAllowed) throw new TRPCError({ code: "FORBIDDEN" });
    if (!(ctx.companyAdministrator || ctx.companyLawyer)) throw new TRPCError({ code: "FORBIDDEN" });

    const where = eq(dividendRounds.companyId, ctx.company.id);
    const rows = await db.query.dividendRounds.findMany({
      columns: { id: true, issuedAt: true, totalAmountInCents: true, numberOfShareholders: true },
      where,
      orderBy: [desc(dividendRounds.id)],
      ...pagination(input),
    });
    const count = await db.$count(dividendRounds, where);
    return { dividendRounds: rows, total: count };
  }),

  get: companyProcedure.input(z.object({ id: z.number() })).query(async ({ ctx, input }) => {
    if (!ctx.company.dividendsAllowed) throw new TRPCError({ code: "FORBIDDEN" });
    if (!(ctx.companyAdministrator || ctx.companyLawyer)) throw new TRPCError({ code: "FORBIDDEN" });

    const dividendRound = await db.query.dividendRounds.findFirst({
      columns: { issuedAt: true, totalAmountInCents: true, numberOfShareholders: true },
      where: and(eq(dividendRounds.id, BigInt(input.id)), eq(dividendRounds.companyId, ctx.company.id)),
    });
    if (!dividendRound) throw new TRPCError({ code: "NOT_FOUND" });

    return dividendRound;
  }),
});
