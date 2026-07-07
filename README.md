# Azure Storage Account Automation using PowerShell and Service Principal

## Opis zadania

Celem zadania było zaprojektowanie i wykonanie procesu automatyzacji infrastruktury chmurowej w Microsoft Azure przy użyciu PowerShella oraz Service Principala.

Skrypt loguje się do Azure bez interaktywnego logowania użytkownika w przeglądarce, a następnie automatycznie tworzy zasób typu Azure Storage Account w dedykowanej Resource Group.

## Wykorzystane technologie

- Microsoft Azure
- PowerShell
- Azure PowerShell module `Az`
- Service Principal
- Azure Role-Based Access Control
- Azure Storage Account

## Założenia rozwiązania

W rozwiązaniu wykorzystano Service Principal, czyli konto techniczne przeznaczone dla aplikacji, skryptów i procesów automatyzujących.

Service Principal uwierzytelnia się do Azure za pomocą trzech głównych parametrów:

- `tenant_id` — identyfikator katalogu Microsoft Entra ID,
- `client_id` — Application ID utworzonego Service Principala,
- `client_secret` — sekret używany jako hasło techniczne.

Po poprawnym uwierzytelnieniu skrypt uzyskuje dostęp do wybranej subskrypcji Azure i wykonuje operacje w określonym zakresie uprawnień.

## Zakres uprawnień

Service Principal otrzymał rolę:

```text
Contributor
```

na poziomie dedykowanej Resource Group:

```text
rg-rekrutacja-patryk
```

Dzięki temu konto techniczne może tworzyć i zarządzać zasobami tylko w tej konkretnej Resource Group, a nie w całej subskrypcji.

Takie podejście ogranicza zakres dostępu i jest bezpieczniejsze niż nadawanie uprawnień globalnych.

## Utworzony zasób

W ramach zadania utworzono Azure Storage Account:

```text
Storage Account Name: stpatryk16882
Resource Group: rg-rekrutacja-patryk
Location: westeurope
SKU: Standard_LRS
Kind: StorageV2
ProvisioningState: Succeeded
```

## Jak działa skrypt

Skrypt wykonuje następujące kroki:

1. Pobiera dane uwierzytelniające Service Principala ze zmiennych środowiskowych.
2. Sprawdza, czy wymagane zmienne są ustawione.
3. Tworzy obiekt `PSCredential` na podstawie `client_id` oraz `client_secret`.
4. Loguje się do Azure za pomocą polecenia `Connect-AzAccount` z parametrem `-ServicePrincipal`.
5. Ustawia odpowiedni kontekst subskrypcji.
6. Sprawdza, czy Storage Account już istnieje.
7. Jeśli Storage Account nie istnieje, tworzy go za pomocą `New-AzStorageAccount`.
8. Jeśli Storage Account już istnieje, wyświetla informację i nie tworzy duplikatu.

## Bezpieczeństwo

Wrażliwe dane, takie jak `client_secret`, nie są zapisane bezpośrednio w kodzie.

Skrypt korzysta ze zmiennych środowiskowych:

```powershell
$env:AZURE_TENANT_ID
$env:AZURE_CLIENT_ID
$env:AZURE_CLIENT_SECRET
$env:AZURE_SUBSCRIPTION_ID
```

Dzięki temu sekret Service Principala nie jest przechowywany w repozytorium GitHub.

## Wymagania

Przed uruchomieniem skryptu należy posiadać:

- konto Azure,
- dostęp do wskazanej subskrypcji,
- zainstalowany moduł `Az` dla PowerShella,
- utworzonego Service Principala,
- nadaną rolę `Contributor` na dedykowanej Resource Group.

Instalacja modułu `Az`:

```powershell
Install-Module Az -Scope CurrentUser -Repository PSGallery -Force
```

## Konfiguracja zmiennych środowiskowych

Przed uruchomieniem skryptu należy ustawić wymagane zmienne środowiskowe:

```powershell
$env:AZURE_TENANT_ID = "YOUR_TENANT_ID"
$env:AZURE_CLIENT_ID = "YOUR_CLIENT_ID"
$env:AZURE_CLIENT_SECRET = "YOUR_CLIENT_SECRET"
$env:AZURE_SUBSCRIPTION_ID = "YOUR_SUBSCRIPTION_ID"
```

Wartości `tenant_id`, `client_id`, `client_secret` i `subscription_id` nie powinny być zapisywane bezpośrednio w kodzie źródłowym.

## Uruchomienie skryptu

Aby uruchomić skrypt, należy wykonać polecenie:

```powershell
.\create-storage.ps1
```

## Przykładowy rezultat

Po poprawnym wykonaniu skryptu Storage Account został utworzony w Azure:

```text
StorageAccountName ResourceGroupName    PrimaryLocation SkuName      Kind      AccessTier ProvisioningState
------------------ -----------------    --------------- -------      ----      ---------- -----------------
stpatryk16882      rg-rekrutacja-patryk westeurope      Standard_LRS StorageV2 Hot        Succeeded
```

Stan `Succeeded` potwierdza, że zasób został utworzony poprawnie.

## Podsumowanie

W trakcie realizacji zadania wykonano następujące kroki:

- zalogowano się do Azure przy użyciu konta użytkownika,
- utworzono Service Principala,
- nadano Service Principalowi rolę `Contributor` na Resource Group,
- zalogowano się do Azure jako Service Principal,
- utworzono Storage Account za pomocą PowerShella,
- potwierdzono utworzenie zasobu poleceniem `Get-AzStorageAccount`.

## Wnioski

Zadanie potwierdza, że możliwe jest automatyczne tworzenie zasobów w Azure bez interaktywnego logowania człowieka w przeglądarce.

Uwierzytelnienie odbywa się programistycznie za pomocą Service Principala, który posiada ograniczone uprawnienia do konkretnej Resource Group. Dzięki temu skrypt może być wykorzystany w automatyzacji, na przykład w procesach CI/CD, deploymentach lub administracji infrastrukturą chmurową.