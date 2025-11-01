import { SignIn } from "@clerk/nextjs";

export default function Page() {
  return (
    <div className="h-full mt-20 flex flex-col gap-y-7 items-center justify-center">
      <span className="text-6xl">Welcome to Smart City.</span>
      <SignIn />
    </div>
  );
}
