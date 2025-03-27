import { zodResolver } from "@hookform/resolvers/zod";
import { useMutation } from "@tanstack/react-query";
import { useState } from "react";
import { useForm } from "react-hook-form";
import { z } from "zod";
import Button from "@/components/Button";
import { CardRow } from "@/components/Card";
import MutationButton from "@/components/MutationButton";
import Status from "@/components/Status";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Form, FormControl, FormDescription, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { useCurrentCompany } from "@/global";
import quickbooksLogo from "@/images/quickbooks.svg";
import { trpc } from "@/trpc/client";
import { assertDefined } from "@/utils/assert";
import { getOauthCode } from "@/utils/oauth";

const quickbooksFormSchema = z.object({
  consultingServicesExpenseAccountId: z.string().min(1, "Please select an expense account"),
  flexileFeesExpenseAccountId: z.string().min(1, "Please select an expense account"),
  equityCompensationExpenseAccountId: z.string().optional(),
  defaultBankAccountId: z.string().min(1, "Please select a bank account"),
  expenseCategoryAccounts: z.record(z.string(), z.string().min(1, "Please select an expense account")),
});

type QuickbooksFormValues = z.infer<typeof quickbooksFormSchema>;

export default function QuickbooksRow() {
  const company = useCurrentCompany();
  const utils = trpc.useUtils();
  const [quickbooksIntegration, { refetch }] = trpc.quickbooks.get.useSuspenseQuery({ companyId: company.id });
  const [expenseCategories] = trpc.expenseCategories.list.useSuspenseQuery({ companyId: company.id });
  const connectQuickbooks = trpc.quickbooks.connect.useMutation();
  const updateQuickbooksConfiguration = trpc.quickbooks.updateConfiguration.useMutation();
  const updateExpenseCategory = trpc.expenseCategories.update.useMutation();
  const disconnectQuickbooks = trpc.quickbooks.disconnect.useMutation({
    onSuccess: () => {
      void refetch();
      setTimeout(() => disconnectQuickbooks.reset(), 2000);
    },
  });

  const [showAccountsModal, setShowAccountsModal] = useState(false);
  const form = useForm<QuickbooksFormValues>({
    resolver: zodResolver(quickbooksFormSchema),
    defaultValues: {
      consultingServicesExpenseAccountId: quickbooksIntegration?.consultingServicesExpenseAccountId ?? "",
      flexileFeesExpenseAccountId: quickbooksIntegration?.flexileFeesExpenseAccountId ?? "",
      equityCompensationExpenseAccountId: quickbooksIntegration?.equityCompensationExpenseAccountId ?? "",
      defaultBankAccountId: quickbooksIntegration?.defaultBankAccountId ?? "",
      expenseCategoryAccounts: Object.fromEntries(
        expenseCategories.map((category) => [category.id.toString(), category.expenseAccountId ?? undefined]),
      ),
    },
  });

  const connectMutation = useMutation({
    mutationFn: async () => {
      const authUrl = await utils.quickbooks.getAuthUrl.fetch({ companyId: company.id });
      const { code, params } = await getOauthCode(authUrl);

      await connectQuickbooks.mutateAsync({
        companyId: company.id,
        code,
        state: assertDefined(params.get("state")),
        realmId: assertDefined(params.get("realmId")),
      });
      setShowAccountsModal(true);
      void refetch();
    },
    onSuccess: () => setTimeout(() => connectMutation.reset(), 2000),
  });

  const saveMutation = useMutation({
    mutationFn: async () => {
      await form.handleSubmit(async (data) => {
        await Promise.all([
          updateQuickbooksConfiguration.mutateAsync({
            companyId: company.id,
            consultingServicesExpenseAccountId: data.consultingServicesExpenseAccountId,
            flexileFeesExpenseAccountId: data.flexileFeesExpenseAccountId,
            equityCompensationExpenseAccountId: data.equityCompensationExpenseAccountId,
            defaultBankAccountId: data.defaultBankAccountId,
          }),
          ...Object.entries(data.expenseCategoryAccounts).map(([id, accountId]) =>
            updateExpenseCategory.mutateAsync({
              companyId: company.id,
              id: BigInt(id),
              expenseAccountId: accountId,
            }),
          ),
        ]);
        setShowAccountsModal(false);
        void refetch();
      })();
    },
    onSuccess: () => setTimeout(() => saveMutation.reset(), 2000),
  });

  const expenseAccountOptions = (quickbooksIntegration?.expenseAccounts ?? []).map((account) => ({
    label: account.name,
    value: account.id,
  }));
  const bankAccountOptions = (quickbooksIntegration?.bankAccounts ?? []).map((account) => ({
    label: account.name,
    value: account.id,
  }));

  const isQuickbooksSetupCompleted =
    quickbooksIntegration?.consultingServicesExpenseAccountId !== null &&
    quickbooksIntegration?.flexileFeesExpenseAccountId !== null &&
    quickbooksIntegration?.defaultBankAccountId !== null;

  const expenseAccountFields = [
    "consultingServicesExpenseAccountId",
    "flexileFeesExpenseAccountId",
    ...(company.flags.includes("equity_compensation") ? (["equityCompensationExpenseAccountId"] as const) : []),
    ...expenseCategories.map((category) => `expenseCategoryAccounts.${category.id}` as const),
  ] as const;
  const expenseAccountLabels: Record<(typeof expenseAccountFields)[number], string> = {
    consultingServicesExpenseAccountId: "consulting services",
    flexileFeesExpenseAccountId: "Flexile fees",
    equityCompensationExpenseAccountId: "equity compensation",
    ...Object.fromEntries(
      expenseCategories.map((category) => [`expenseCategoryAccounts.${category.id}`, `${category.name} expenses`]),
    ),
  };

  return (
    <CardRow>
      <div className="flex justify-between gap-2">
        <div>
          <div className="flex items-center gap-2">
            <h2 className="text-xl font-bold">
              <img src={quickbooksLogo.src} className="inline size-6" alt="" />
              &ensp;QuickBooks
            </h2>
            {quickbooksIntegration?.status === "active" ? <Status variant="success">Connected</Status> : null}
            {quickbooksIntegration?.status === "out_of_sync" ? (
              <Status variant="critical">Needs reconnecting</Status>
            ) : null}
            {quickbooksIntegration && !isQuickbooksSetupCompleted ? (
              <Status variant="critical">Setup required</Status>
            ) : null}
          </div>
          <p className="text-gray-400">Sync invoices, payments, and expenses with your QuickBooks account.</p>
        </div>
        <div className="flex flex-wrap items-center justify-end gap-4">
          {!quickbooksIntegration || quickbooksIntegration.status === "out_of_sync" ? (
            <MutationButton mutation={connectMutation} loadingText="Connecting...">
              Connect
            </MutationButton>
          ) : (
            <>
              <MutationButton
                mutation={disconnectQuickbooks}
                param={{ companyId: company.id }}
                idleVariant="outline"
                loadingText="Disconnecting..."
                successText="Disconnected!"
              >
                Disconnect
              </MutationButton>
              {!isQuickbooksSetupCompleted && <Button onClick={() => setShowAccountsModal(true)}>Finish setup</Button>}
            </>
          )}
        </div>
      </div>

      <Dialog open={showAccountsModal} onOpenChange={setShowAccountsModal}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Set up QuickBooks integration</DialogTitle>
          </DialogHeader>
          <Form {...form}>
            {expenseAccountFields.map((name) => (
              <FormField
                key={name}
                control={form.control}
                name={name}
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Expense account for {expenseAccountLabels[name]}</FormLabel>
                    <FormControl>
                      <Select value={field.value ?? ""} onValueChange={field.onChange}>
                        <SelectTrigger>
                          <SelectValue placeholder="Select an account" />
                        </SelectTrigger>
                        <SelectContent align="center">
                          {expenseAccountOptions.map((option) => (
                            <SelectItem key={option.value} value={option.value}>
                              {option.label}
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    </FormControl>
                    {name === "consultingServicesExpenseAccountId" ? (
                      <FormDescription>This can be overridden for individual roles.</FormDescription>
                    ) : null}
                    <FormMessage />
                  </FormItem>
                )}
              />
            ))}

            <div className="border-b border-gray-100" />

            <FormField
              control={form.control}
              name="defaultBankAccountId"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Bank account</FormLabel>
                  <FormControl>
                    <Select value={field.value} onValueChange={field.onChange}>
                      <SelectTrigger>
                        <SelectValue placeholder="Select an account" />
                      </SelectTrigger>
                      <SelectContent>
                        {bankAccountOptions.map((option) => (
                          <SelectItem key={option.value} value={option.value}>
                            {option.label}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <div className="mt-6 flex justify-between">
              <div className="ml-auto flex gap-2">
                <MutationButton mutation={saveMutation} loadingText="Saving..." successText="Saved!">
                  Save
                </MutationButton>
              </div>
            </div>
          </Form>
        </DialogContent>
      </Dialog>
    </CardRow>
  );
}
