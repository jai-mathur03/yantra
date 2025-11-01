"use client";

import {
  SignedIn,
  SignedOut,
  SignInButton,
  SignUpButton,
  UserButton,
} from "@clerk/nextjs";
import Link from "next/link";
import { usePathname } from "next/navigation";

const Navbar = () => {
  const pathname = usePathname();
  return (
    <nav className="z-50 absolute top-1 w-[100vw] flex justify-around items-center p-4 gap-4 h-16">
      <Link href="/">
        <span
          className={`relative after:absolute after:left-1/2 after:bottom-0 after:h-[2px] after:bg-black after:transition-all after:duration-300 after:transform after:origin-center ${
            pathname === "/"
              ? "transition-all duration-500 text-orange-500 underline"
              : "after:w-0 after:left-1/2 hover:after:w-full hover:after:left-0"
          }`}
        >
          Home
        </span>
      </Link>
      <Link href="/wind">
        <span
          className={`relative after:absolute after:left-1/2 after:bottom-0 after:h-[2px] after:bg-black after:transition-all after:duration-300 after:transform after:origin-center ${
            pathname === "/wind"
              ? "transition-all duration-500 text-orange-500 underline"
              : "after:w-0 after:left-1/2 hover:after:w-full hover:after:left-0"
          }`}
        >
          Wind data
        </span>
      </Link>
      <Link href="/solar">
        <span
          className={`relative after:absolute after:left-1/2 after:bottom-0 after:h-[2px] after:bg-black after:transition-all after:duration-300 after:transform after:origin-center ${
            pathname === "/solar"
              ? "transition-all duration-500 text-orange-500 underline"
              : "after:w-0 after:left-1/2 hover:after:w-full hover:after:left-0"
          }`}
        >
          Solar Data
        </span>
      </Link>
      <Link href="/settings">
        <span
          className={`relative after:absolute after:left-1/2 after:bottom-0 after:h-[2px] after:bg-black after:transition-all after:duration-300 after:transform after:origin-center ${
            pathname === "/settings"
              ? "transition-all duration-500 text-orange-500 underline"
              : "after:w-0 after:left-1/2 hover:after:w-full hover:after:left-0"
          }`}
        >
          Settings
        </span>
      </Link>
      <SignedOut>
        <SignInButton />
        <SignUpButton />
      </SignedOut>
      <SignedIn>
        <UserButton
          appearance={{
            elements: {
              userButtonAvatarBox: "w-12 h-12",
            },
          }}
        />
      </SignedIn>
    </nav>
  );
};

export default Navbar;
