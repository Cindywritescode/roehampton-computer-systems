global main
extern printf

SECTION .data
  a dd 0
  b dd 1
  limit dd 500000
  counter dd 1
  msg db "f(%d) = %d",0xa,0x0
  summary db "Total %d generated under %d limit",0xa,0x0

SECTION .bss
  c resd 1

SECTION .text

main:
  call print_a
  call count
loop:
  call print_b
  call compute_next
  call count
  call compare
  call end

count:
  mov eax, [counter]
  inc eax
  mov dword [counter], eax
  ret

compare:
  mov eax, [c]
  mov ebx, [limit]
  cmp ebx, eax
  jg loop
  ret

compute_next:
  mov eax, [a]
  add eax, [b]
  mov dword [c], eax
  mov eax, [b]
  mov dword [a], eax
  mov eax, [c]
  mov dword [b], eax
  ret

print_a:
  mov eax, [a]
  jmp print
print_b:
  mov eax, [b]
print:
  mov ecx, [counter]
  push eax
  push ecx
  push msg
  call printf
  pop ebx
  pop ebx
  pop ebx
  ret

end:
  mov ebx, [counter]
  dec ebx
  mov eax, [limit]
  push eax
  push ebx
  push summary
  call printf
  mov eax, 1
  int 0x80
  ret
