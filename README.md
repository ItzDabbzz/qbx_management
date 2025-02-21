![qbx_management](https://github.com/Qbox-project/qbx_management/assets/22198949/97380b5b-3954-4aa5-8b67-d73ffc99237f)

# qbx_management
Business and gang management menu for Qbox

## Features
- Customizable business and gang menu locations
- View current employees and gang members
- Hire, fire, promote, and demote both online and offline employees and gang members
- Logging the hiring and firing of employees and gang members
- Bank Managment
- Payroll Management
- Using [fd_banking](https://felis.gg/product/banking)
- Support?
  - Respectfully no, figure it out yourself 💜

## Images
![bossmenu](https://raw.githubusercontent.com/ItzDabbzz/qbx_management/refs/heads/main/.github/images/boss_menu.png)
![banking](https://raw.githubusercontent.com/ItzDabbzz/qbx_management/refs/heads/main/.github/images/banking.png)
![payroll_menu](https://raw.githubusercontent.com/ItzDabbzz/qbx_management/refs/heads/main/.github/images/payroll_menu.png)
![pay_history](https://raw.githubusercontent.com/ItzDabbzz/qbx_management/refs/heads/main/.github/images/payroll_history.png)
![pay_manage](https://raw.githubusercontent.com/ItzDabbzz/qbx_management/refs/heads/main/.github/images/payroll_salaries_edit.png)

## Basic Install Docs
- Go into `qbx_core > server > loops.lua`
- Find `pay(player)` Then Replace With The Following
```lua
local function pay(player)
    local job = player.PlayerData.job
        -- Check for custom salary first from our management_payroll table
    local customSalary = MySQL.scalar.await('SELECT salary FROM management_payroll WHERE citizenid = ? AND job = ?', {
        player.PlayerData.citizenid,
        job.name
    })
    -- Use custom salary if set, otherwise fall back to default grade payment
    local payment = customSalary or GetJob(job.name).grades[job.grade.level].payment or job.payment
    if payment <= 0 then return end
    if not GetJob(job.name).offDutyPay and not job.onduty then return end
    if not config.money.paycheckSociety then
        config.sendPaycheck(player, payment)
        return
    end
    local account = config.getSocietyAccount(job.name)
    if not account then -- Checks if player is employed by a society
        config.sendPaycheck(player, payment)
        return
    end
    if account < payment then -- Checks if company has enough money to pay society
        Notify(player.PlayerData.source, locale('error.company_too_poor'), 'error')
        return
    end
    config.removeSocietyMoney(job.name, payment)
    config.sendPaycheck(player, payment)
        -- Record payment in history
    MySQL.insert('INSERT INTO management_payroll_history (citizenid, job, amount) VALUES (?, ?, ?)', {
        player.PlayerData.citizenid,
        job.name,
        payment
    })
end
```