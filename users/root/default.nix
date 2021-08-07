{ ... }:
# recommend using `hashedPassword`
{
  users.users.root = {
    hashedPassword = "$5$F031qapDiRG6FKIf$h7H1UlwGfc.1HRW7ZzZFNEwMxKOEWddbXsz0TNK/bY3";
    isSystemUser = true;
  };
}
