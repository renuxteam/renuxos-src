# RenuxOS — Zig Kernel Era

<p align="center">
  <img src="https://github.com/user-attachments/assets/05780bda-8ccc-4c05-a699-7f1d8fdc8d43" alt="Captura de tela_2025-06-14_21-45-52">
</p>



Welcome to the new era of **RenuxOS**.

I’m Renan Lucas, the creator of RenuxOS. After a lot of exploration using Rust in the early stages of the project, I decided to take RenuxOS into a new, lighter, and more focused phase — with a full rewrite of the kernel in **Zig**.

This marks the beginning of a redesigned system built for clarity, modularity, and hacker-level control.

---

## 📌 What is RenuxOS?

**RenuxOS** is a hobbyist operating system designed to be:
- Hybrid kernel (mixing micro and monolithic features)
- Modular and customizable
- Written mainly in **Zig**, with parts in C and Assembly
- Fully built from scratch using a monolithic repository structure

---

## 🎯 Why rewrite it in Zig?

Rust is a powerful language, but for a low-level OS project like this, it became too heavy for my current flow. As someone who’s neurodivergent (AuDHD), I realized Zig offers me:
- Fewer distractions from complex compiler errors
- A cleaner and more predictable mental model
- Direct integration with C and assembly
- No dependency on Cargo or external build systems

This doesn't mean Rust is bad — it just means Zig fits **better** for the future of this project.

---

## 🔧 Project Status

This is a **complete reboot** of the original `renuxos-src` repository. If you're looking for the old Rust-based version, it's been archived here:
👉 [renuxos-src_old](https://github.com/renuxteam/renuxos-src_old)
