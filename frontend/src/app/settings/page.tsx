"use client";

import { easeInOut, motion } from "framer-motion";
import { useRouter } from "next/navigation";
import { toast, Toaster } from "sonner";
import axios from "axios";
import { zodResolver } from "@hookform/resolvers/zod";
import { Controller, useForm } from "react-hook-form";
import { z } from "zod";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import Navbar from "@/components/navbar";

const SettingsPage = () => {
  const formSchema = z.object({
    panelArea: z.number().min(0.1, { message: "Panel area is required" }),
    efficiency: z.number().min(1, { message: "Efficiency is required" }),
    ageOfPanel: z
      .number()
      .min(1, { message: "Enter value greater than 0" })
      .default(0),
  });
  type FormData = z.infer<typeof formSchema>;

  const {
    handleSubmit,
    control,
    formState: { errors },
  } = useForm<FormData>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      panelArea: 0,
      efficiency: 0,
      ageOfPanel: 0,
    },
  });
  const router = useRouter();
  const onSubmit = async (data: FormData) => {
    console.log("yay");
    const { panelArea, ageOfPanel } = data;
    try {
      const response = await axios.post(
        "https://coding-relay-be.onrender.com/solar/post",
        {
          panel_area: Number(panelArea),
          efficiency_rating: 0,
          panel_age: ageOfPanel,
        }
      );
      if (response.status === 200) {
        toast.success("Data submitted successfully");
        setTimeout(() => {
          router.push("/solar");
        }, 1000);
      } else {
        toast.error("Something went wrong");
      }
    } catch (error) {
      toast.error("Submission failed. Try again.");
      console.error(error);
    }
  };
  return (
    <>
      <Navbar />
      <motion.div
        key="points"
        initial={{ opacity: 0, y: 30 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5, delay: 1.5, ease: easeInOut }}
        className="flex flex-col min-h-[60vh] text-center items-center justify-start"
      >
        <motion.form
          key="form"
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, ease: easeInOut, delay: 1.5 }}
          className="flex flex-col items-center justify-around h-1/2 z-50"
          onSubmit={handleSubmit(onSubmit)}
        >
          <span className="text-5xl mt-32">Enter panel details</span>
          <div className="mt-5 flex items-center justify-center w-full gap-x-10">
            <div className="text-xl w-[70%] flex flex-col items-center justify-center gap-y-6">
              <span>Panel Area</span>
              <Controller
                name="panelArea"
                control={control}
                render={({ field }) => (
                  <Select
                    {...field}
                    value={field.value?.toString()}
                    onValueChange={(value) => field.onChange(Number(value))}
                  >
                    <SelectTrigger className="text-base rounded-lg w-[10.3rem] h-[3.5rem] bg-gradient-to-r from-[#ff9800] to-[#f57c00] text-white">
                      <SelectValue placeholder="Required" />
                    </SelectTrigger>
                    <SelectContent className="bg-black text-white border-none absolute z-50">
                      <SelectItem
                        className="hover:text-black hover:bg-white"
                        value="1.2"
                      >
                        1.2 m<sup>2</sup>
                      </SelectItem>
                      <SelectItem
                        className="hover:text-black hover:bg-white"
                        value="1.6"
                      >
                        1.6 m<sup>2</sup>
                      </SelectItem>
                      <SelectItem
                        className="hover:text-black hover:bg-white"
                        value="1.8"
                      >
                        1.8 m<sup>2</sup>
                      </SelectItem>
                    </SelectContent>
                  </Select>
                )}
              />
              {errors.panelArea && (
                <span className="text-red-500 text-sm -mt-5">
                  {errors.panelArea.message}
                </span>
              )}
              <span>Age of Panel</span>
              <Controller
                name="ageOfPanel"
                control={control}
                render={({ field }) => (
                  <input
                    placeholder="Required"
                    {...field}
                    type="number"
                    value={field.value === 0 ? "" : field.value} // Clear default 0 when typing
                    onChange={(e) => {
                      const value = e.target.value;
                      field.onChange(value === "" ? 0 : Number(value)); // Handle empty string case
                    }}
                    className="sm:w-40 w-36 text-white bg-gradient-to-r from-[#ff9800] to-[#f57c00] p-3 rounded-lg"
                  />
                )}
              />
              {errors.ageOfPanel && (
                <span className="text-red-500 text-sm w-40 h-2 m-5 p-0 sm:-mt-2 -mt-4 sm:mb-0 mb-8">
                  {errors.ageOfPanel.message}
                </span>
              )}
            </div>
          </div>
        </motion.form>
        <button
          onClick={() =>
            onSubmit({ panelArea: 0, efficiency: 0, ageOfPanel: 0 })
          }
          className="mb-6 mt-10 relative w-[10.5rem] h-12
                p-1 rounded-lg bg-gradient-to-r from-[#ff9800] to-[#f57c00]
                transition-all duration-500 group"
        >
          <div className="flex items-center justify-center w-full h-full text-2xl text-white bg-gradient-to-r from-[#ff9800] to-[#f57c00] rounded-lg transition-all duration-500 group-hover:shadow-lg group-hover:shadow-black group-hover:bg-transparent group-hover:text-[1.8rem]">
            Save
          </div>
        </button>
      </motion.div>
      <Toaster />
    </>
  );
};

export default SettingsPage;
