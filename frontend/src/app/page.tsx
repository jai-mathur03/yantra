"use client";

import { AnimatePresence, easeInOut, motion } from "framer-motion";
import Navbar from "@/components/navbar";
import Link from "next/link";
import Image from "next/image";

export default function Home() {
  return (
    <>
      <div className="h-full w-full relative">
        <AnimatePresence mode="popLayout">
          <motion.div
            key="old"
            initial={{ scale: 1, x: 0, y: 0 }}
            animate={{ scale: 10, x: 225, y: 225, opacity: 0 }}
            exit={{ scale: 10, x: 225, y: 225, opacity: 0 }}
            transition={{ duration: 2, ease: easeInOut }}
            className="absolute top-[52vh] left-[153vh] w-96 h-96 -z-50 bg-[#f4b643] rounded-full"
          ></motion.div>
        </AnimatePresence>
        <AnimatePresence mode="sync">
          <motion.div
            key="circle"
            initial={{ y: -170, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ duration: 0.4, ease: easeInOut, delay: 1.5 }}
            className="-top-40 -right-16 w-80 h-80 bg-[#ffa500] rounded-full absolute"
          ></motion.div>
          <Navbar />
          <span className="text-7xl mt-48 absolute left-72">
            Welcome to Smart City
          </span>
          <Link
            href="/settings"
            className="text-3xl absolute left-[37rem] mt-72"
          >
            Go to settings
          </Link>
          <div className="mt-32 absolute -bottom-[40rem] left-[15rem] flex items-center justify-center w-[58rem] h-fit gap-x-5 p-2">
            <Link href="/solar">
              <div className="flex flex-col items-center justify-center w-56 h-56 bg-gradient-to-r from-[#ff9800] to-[#f57c00] rounded-lg">
                <span className="text-white text-2xl mt-4">Solar</span>
                <br />
                <Image src="/solar.png" alt="solar" width={150} height={150} />
              </div>
            </Link>
            <Link href="/wind">
              <div className="flex flex-col items-center justify-center w-56 h-56 bg-gradient-to-r from-[#ff9800] to-[#f57c00] rounded-lg m-auto">
                <span className="text-white text-2xl mt-10">Wind</span>
                <Image src="/wind.png" alt="wind" width={150} height={150} />
              </div>
            </Link>
            {/* <Link href="/hydro">
              <div className="flex flex-col items-center justify-center w-56 h-56 bg-gradient-to-r from-[#ff9800] to-[#f57c00] rounded-lg">
                <span className="text-white text-2xl mt-10">Hydro</span>
                <br />
                <Image src="/hydro.png" alt="hydro" width={180} height={180} />
              </div>
            </Link> */}
          </div>
          <motion.div
            key="new"
            initial={{ y: 170, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ duration: 0.4, ease: easeInOut, delay: 1.5 }}
            className="-left-28 -bottom-[55.5rem] w-80 h-80 bg-[#d16710] rounded-full absolute"
          ></motion.div>
        </AnimatePresence>
      </div>
    </>
  );
}
